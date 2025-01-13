import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Core/utils/SharedPrefsLocal.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/register/domain/entities/user_model_entity.dart';

import '../../domain/entities/materail_enitiy.dart';
import '../../domain/use_cases/added_matrails_use_case.dart';
import '../../domain/use_cases/delete_matrails_use_case.dart';
import '../../domain/use_cases/get_materails_use_case.dart';
import '../../domain/use_cases/update_matrails_use_case.dart';

part 'inventory_view_model_state.dart';

@injectable
class InventoryViewModelCubit extends Cubit<InventoryViewModelState> {
  final AddedMaterailUseCase addedMaterailUseCase;
  final GetMaterailUseCase getMaterailUseCase;
  final DeleteMaterialUseCase deleteMaterailUseCase;
  final UpdateMaterialUseCase updateMaterailUseCase;

  InventoryViewModelCubit({
    required this.addedMaterailUseCase,
    required this.getMaterailUseCase,
    required this.deleteMaterailUseCase,
    required this.updateMaterailUseCase,
  }) : super(InventoryViewModelInitial());
  static InventoryViewModelCubit get(context, [bool? listen]) =>
      BlocProvider.of(context, listen: listen ?? false);

  bool isLoading = false;
  bool isInitialLoad = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String? unit;
  final formKey = GlobalKey<FormState>();
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  double opacity = 0.0;
  List<MaterailEntity> materails = [];
  List<MaterailEntity> filteredItems = [];
  late UserAndAdminModelEntity user;

  UserAndAdminModelEntity? getUser() {
    var user = SharedPrefsLocal.getData(key: StringManager.userAdmin);
    return user;
  }

  void doAnimation(SingleTickerProviderStateMixin single) {
    animationController = AnimationController(
        vsync: single, duration: const Duration(seconds: 1));

    slideAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));
  }

  void searchMethod() {
    filteredItems = materails.where((item) {
      return item.name!
          .toLowerCase()
          .contains(searchController.text.toLowerCase());
    }).toList();
    if (filteredItems.isEmpty) {
      emit(InventoryNoSearchResultMaterail());
    } else {
      emit(InventorySearchMaterail());
    }
  }

  void addedMaterails() async {
    isLoading = true;
    emit(InventoryAddedMaterailLoading());
    MaterailEntity materail = MaterailEntity(
      name: nameController.text,
      quantity: int.parse(quantityController.text),
      unit: unit,
    );
    var data = await addedMaterailUseCase.invoke(materail);
    data.fold(
      (failure) {
        isLoading = false;
        emit(InventoryAddedMaterailError(error: failure));
      },
      (success) {
        isLoading = false;
        emit(InventoryAddedMaterailSuccess());
        getMaterails();
      },
    );
  }

  void updateMaterails(String id) async {
    isLoading = true;
    emit(InventoryUpdateMaterailLoading());
    MaterailEntity materail = MaterailEntity(
      id: id,
      name: nameController.text,
      quantity: int.parse(quantityController.text),
      unit: unit,
    );
    var data = await updateMaterailUseCase.invoke(
        materail.id, materail.name!, materail.quantity!, materail.unit!);
    data.fold(
      (failure) {
        isLoading = false;
        emit(InventoryUpdateMaterailError(error: failure));
      },
      (success) {
        isLoading = false;
        emit(InventoryUpdateMaterailSuccess());
        getMaterails();
      },
    );
  }

  void getMaterails() async {
    isLoading = true;
    isInitialLoad = true;
    emit(InventoryGetMaterailLoading());
    var data = await getMaterailUseCase.fetchMaterialsList();
    data.fold(
      (failure) {
        isLoading = false;
        isInitialLoad = false;
        emit(InventoryGetMaterailError(error: failure));
      },
      (materials) {
        isLoading = false;
        isInitialLoad = false;
        materails = materials;
        filteredItems = materials;
        emit(InventoryGetMaterailSuccess(data: materials));
      },
    );
  }

  void deleteMaterails(String key, int index) async {
    isLoading = true;
    emit(InventoryDeleteMaterailLoading());
    var data = await deleteMaterailUseCase.invoke(key);
    data.fold(
      (failure) {
        isLoading = false;
        emit(InventoryDeleteMaterailError(error: failure));
      },
      (success) {
        isLoading = false;
        emit(InventoryDeleteMaterailSuccess());
        getMaterails();
      },
    );
  }

  void incrementQuantity(MaterailEntity item) async {
    item.quantity = (item.quantity ?? 0) + 1;
    emit(InventoryUpdateMaterailSuccess()); // Optimistically update the UI
    var data = await updateMaterailUseCase.invoke(
        item.id, item.name!, item.quantity!, item.unit!);
    data.fold(
      (failure) {
        emit(InventoryUpdateMaterailError(error: failure));
      },
      (success) {
        emit(InventoryUpdateMaterailSuccess());
      },
    );
  }

  void decrementQuantity(MaterailEntity item) async {
    if ((item.quantity ?? 0) > 0) {
      item.quantity = (item.quantity ?? 0) - 1;
      emit(InventoryUpdateMaterailSuccess()); // Optimistically update the UI
      var data = await updateMaterailUseCase.invoke(
          item.id, item.name!, item.quantity!, item.unit!);
      data.fold(
        (failure) {
          emit(InventoryUpdateMaterailError(error: failure));
        },
        (success) {
          emit(InventoryUpdateMaterailSuccess());
        },
      );
    }
  }

  void clearFields() {
    nameController.clear();
    quantityController.clear();
    unit = null;
  }
}

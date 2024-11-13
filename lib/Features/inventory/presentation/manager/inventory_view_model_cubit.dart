import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Core/utils/SharedPrefsLocal.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/register/domain/entities/user_model_entity.dart';

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
  late UserAndAdminModelEntity user;
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  double opacity = 0.0;
  List<MaterailEntity> materails = [];
  List<MaterailEntity> filteredItems = [];

  UserAndAdminModelEntity? getUser() {
    var user = SharedPrefsLocal.getData(key: StringManager.keyUserAdmin);
    return user;
  }

  void doAnimation(SingleTickerProviderStateMixin single) {
    animationController = AnimationController(
        vsync: single, duration: const Duration(seconds: 1));

    slideAnimation =
        Tween<Offset>(begin: const Offset(-2, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void searchMethod() {
    filteredItems = materails.where((item) {
      var name = item.name;
      return name is String &&
          name.toLowerCase().contains(searchController.text.toLowerCase());
    }).toList();
    emit(InventorySearchMaterail());
  }

  void addedMaterails() async {
    isLoading = true;
    emit(InventoryAddedMaterailLoading());
    MaterailEntity materail = MaterailEntity(
        name: nameController.text,
        quantity: int.parse(quantityController.text));
    var data = await addedMaterailUseCase.invoke(materail);
    data.fold(
      (f) {
        isLoading = false;
        emit(InventoryAddedMaterailError(error: f));
      },
      (r) {
        isLoading = false;
        emit(InventoryAddedMaterailSuccess());
      },
    );
  }

  void updateMaterails(String id) async {
    isLoading = true;
    emit(InventoryUpdateMaterailLoading());
    MaterailEntity materail = MaterailEntity(
        id: id,
        name: nameController.text,
        quantity: int.parse(quantityController.text));
    var data = await updateMaterailUseCase.invoke(
        materail.id, materail.name!, materail.quantity!);
    data.fold(
      (f) {
        isLoading = false;
        emit(InventoryUpdateMaterailError(error: f));
      },
      (r) {
        isLoading = false;
        emit(InventoryUpdateMaterailSuccess());
      },
    );
  }

  void getMaterails() async {
    isLoading = true;
    opacity = 0.0;
    emit(InventoryGetMaterailLoading());
    var data = await getMaterailUseCase.fetchMaterialsList();
    data.fold(
      (f) {
        isLoading = false;
        emit(InventoryGetMaterailError(error: f));
      },
      (r) {
        isLoading = false;
        materails = r;
        filteredItems = materails;
        emit(InventoryGetMaterailSuccess(data: r));
        WidgetsBinding.instance.addPostFrameCallback((_) {
          opacity = 1.0;
          emit(InventoryAnimationMaterailSuccess());
          animationController.forward();
        });
      },
    );
  }

  void deleteMaterails(String key) async {
    isLoading = true;
    emit(InventoryDeleteMaterailLoading());
    var data = await deleteMaterailUseCase.invoke(key);
    data.fold(
      (f) {
        isLoading = false;
        emit(InventoryDeleteMaterailError(error: f));
      },
      (r) {
        isLoading = false;
        emit(InventoryDeleteMaterailSuccess());
      },
    );
  }
}

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:pesticides/Core/errors/failures.dart';

import '../../domain/use_cases/added_matrails_use_case.dart';
import '../../domain/use_cases/delete_matrails_use_case.dart';
import '../../domain/use_cases/get_materails_use_case.dart';

part 'inventory_view_model_state.dart';
@injectable

class InventoryViewModelCubit extends Cubit<InventoryViewModelState> {
  final AddedMaterailUseCase addedMaterailUseCase;
  final GetMaterailUseCase getMaterailUseCase;
  final DeleteMaterialUseCase deleteMaterailUseCase;

  InventoryViewModelCubit({
    required this.addedMaterailUseCase,
    required this.getMaterailUseCase,
    required this.deleteMaterailUseCase,
  }) : super(InventoryViewModelInitial());
  static InventoryViewModelCubit get(context, [bool? listen]) => BlocProvider.of(context, listen: listen ?? false);

  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> materails = [];
  List<Map<String, dynamic>> filteredItems = [];

  void filterItems() {
    filteredItems = materails
        .where((item) {
      // Ensure item["name"] is treated as a string, and handle cases where it's null
      var name = item["name"];
      return name is String && name.toLowerCase().contains(searchController.text.toLowerCase());
    })
        .toList();
    print(filteredItems);
    // Emit the updated state with filtered items
    emit(InventorySearchMaterail());
  }


  // Add material
  void addedMaterails() async {
    isLoading = true;
    emit(InventoryAddedMaterailLoading());
    Map<String, dynamic> materialData = {
      "name": nameController.text,
      "quantity": int.parse(quantityController.text),
    };
    var data = await addedMaterailUseCase.invoke(materialData);
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

  // Get materials list
  void getMaterails() async {
    isLoading = true;
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
        filteredItems =materails;
        emit(InventoryGetMaterailSuccess(data: r));
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

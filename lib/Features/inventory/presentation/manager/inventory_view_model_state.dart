part of 'inventory_view_model_cubit.dart';

@immutable
abstract class InventoryViewModelState {}

class InventoryViewModelInitial extends InventoryViewModelState {}

class InventoryGetMaterailLoading extends InventoryViewModelState {}

class InventoryGetMaterailSuccess extends InventoryViewModelState {
  final List<MaterailEntity> data;

  InventoryGetMaterailSuccess({required this.data});
}

class InventoryGetMaterailError extends InventoryViewModelState {
  final Failure error;

  InventoryGetMaterailError({required this.error});
}

class InventorySearchMaterail extends InventoryViewModelState {}

class InventoryNoSearchResultMaterail extends InventoryViewModelState {}

class InventoryAddedMaterailLoading extends InventoryViewModelState {}

class InventoryAddedMaterailSuccess extends InventoryViewModelState {}

class InventoryAddedMaterailError extends InventoryViewModelState {
  final Failure error;

  InventoryAddedMaterailError({required this.error});
}

class InventoryUpdateMaterailLoading extends InventoryViewModelState {}

class InventoryUpdateMaterailSuccess extends InventoryViewModelState {}

class InventoryUpdateMaterailError extends InventoryViewModelState {
  final Failure error;

  InventoryUpdateMaterailError({required this.error});
}

class InventoryDeleteMaterailLoading extends InventoryViewModelState {}

class InventoryDeleteMaterailSuccess extends InventoryViewModelState {}

class InventoryDeleteMaterailError extends InventoryViewModelState {
  final Failure error;

  InventoryDeleteMaterailError({required this.error});
}

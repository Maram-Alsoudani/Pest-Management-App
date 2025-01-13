part of 'category_cubit.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}
final class CategorySuccessState extends CategoryState {
  UserAndAdminModelEntity userAndAdminModelEntity;
  CategorySuccessState({required this.userAndAdminModelEntity});
}
final class CategoryFaluireState extends CategoryState {
  Failure error;
  CategoryFaluireState({required this.error});
}
final class CategoryLoadingState extends CategoryState {}
final class CategoryAnimationState extends CategoryState {}


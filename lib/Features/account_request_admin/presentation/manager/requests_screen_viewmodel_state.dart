part of 'requests_screen_viewmodel_cubit.dart';

@immutable
sealed class RequestsScreenViewmodelState {}

final class RequestsScreenViewmodelInitial extends RequestsScreenViewmodelState {}
final class RequestsScreenViewmodelLoading extends RequestsScreenViewmodelState {}
final class RequestsScreenViewmodelSuccess extends RequestsScreenViewmodelState {}
final class RequestsScreenViewmodelError extends RequestsScreenViewmodelState {
  final Failure error;

  RequestsScreenViewmodelError({required this.error});
}

final class AcceptRequestsScreenViewmodelLoading extends RequestsScreenViewmodelState {}
final class AcceptRequestsScreenViewmodelError extends RequestsScreenViewmodelState {
  final Failure error;

  AcceptRequestsScreenViewmodelError({required this.error});
}
final class AcceptRequestsScreenViewmodelSuccess extends RequestsScreenViewmodelState {}


final class DeclineRequestsScreenViewmodelLoading extends RequestsScreenViewmodelState {}
final class DeclineRequestsScreenViewmodelError extends RequestsScreenViewmodelState {
  final Failure error;

  DeclineRequestsScreenViewmodelError({required this.error});
}
final class DeclineRequestsScreenViewmodelSuccess extends RequestsScreenViewmodelState {}


final class DeleteRequestsScreenViewmodelLoading extends RequestsScreenViewmodelState {}
final class DeleteRequestsScreenViewmodelError extends RequestsScreenViewmodelState {
  final Failure error;

  DeleteRequestsScreenViewmodelError({required this.error});
}
final class DeleteRequestsScreenViewmodelSuccess extends RequestsScreenViewmodelState {}


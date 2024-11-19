part of 'user_request_account_view_model_cubit.dart';


 class UserRequestAccountState {}

 class UserRequestAccountViewModelInitial extends UserRequestAccountState {}
 class UserRequestAccountViewModelLoading extends UserRequestAccountState {}
 class UserRequestAccountViewModelSuccess extends UserRequestAccountState {

 }
class UserRequestAccountViewModelAnimation extends UserRequestAccountState {

}
class UserRequestAccountViewModelChangeImage extends UserRequestAccountState {

}


 class UserRequestAccountViewModelError extends UserRequestAccountState {
  Failure failure;

  UserRequestAccountViewModelError({required this.failure});
}

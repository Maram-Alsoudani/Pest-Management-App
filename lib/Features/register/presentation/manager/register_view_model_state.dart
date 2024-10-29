part of 'register_view_model_cubit.dart';


 class RegisterViewModelState {}

 class RegisterViewModelInitial extends RegisterViewModelState {}
 class RegisterViewModelLoading extends RegisterViewModelState {}
 class RegisterViewModelSuccess extends RegisterViewModelState {

 }
class RegisterViewModelAnimation extends RegisterViewModelState {

}
class RegisterViewModelChangeImage extends RegisterViewModelState {

}


 class RegisterViewModelError extends RegisterViewModelState {
  Failure failure;

  RegisterViewModelError({required this.failure});
}

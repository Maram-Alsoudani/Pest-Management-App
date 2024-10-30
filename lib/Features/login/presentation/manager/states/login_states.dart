

abstract class LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class LoginViewModelAnimation extends LoginStates {}

class LoginErrorState extends LoginStates {
  String errorMsg;

  LoginErrorState({required this.errorMsg});
}

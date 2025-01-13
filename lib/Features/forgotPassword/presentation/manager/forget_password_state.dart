import 'package:bug_away/Core/errors/failures.dart';

abstract class ForgetPasswordState {}

class ForgetPasswordInitialState extends ForgetPasswordState {}

class ForgetPasswordLoadingState extends ForgetPasswordState {}

class ForgetPasswordErrorState extends ForgetPasswordState {
  Failure failure;
  ForgetPasswordErrorState({required this.failure});
}

class ForgetPasswordSuccessState extends ForgetPasswordState {}

class ForgetPasswordAnimationState extends ForgetPasswordState {}

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Features/forgotPassword/presentation/manager/forget_password_state.dart';

import '../../domain/use_cases/forget_password_user_case.dart';

@injectable
class ForgetPasswordViewModel extends Cubit<ForgetPasswordState> {
  var emailController = TextEditingController();

  ForgetPasswordUserCase forgetPasswordUseCase;
  ForgetPasswordViewModel({required this.forgetPasswordUseCase})
      : super(ForgetPasswordInitialState());
  //todo hold data - handel logic
  void forgetPassword() async {
    emit(ForgetPasswordLoadingState());
    var either = await forgetPasswordUseCase.invoke(emailController.text);
    either.fold((l) {
      emit(ForgetPasswordErrorState(failure: l));
    }, (r) => emit(ForgetPasswordSuccessState()));
  }
}

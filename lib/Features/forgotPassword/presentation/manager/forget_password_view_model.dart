import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Features/forgotPassword/presentation/manager/forget_password_state.dart';

import '../../domain/use_cases/forget_password_user_case.dart';

@injectable
class ForgetPasswordViewModel extends Cubit<ForgetPasswordState> {
  //todo========================*( ForgetPassword )*=================
  var forgetPasswordFormKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  bool isLoading = false;
  static ForgetPasswordViewModel get(context) =>
      BlocProvider.of<ForgetPasswordViewModel>(context);

  ForgetPasswordUserCase forgetPasswordUseCase;
  ForgetPasswordViewModel({required this.forgetPasswordUseCase})
      : super(ForgetPasswordInitialState());
  //todo hold data - handel logic
  void forgetPassword() async {
    isLoading = true;
    emit(ForgetPasswordLoadingState());
    var either = await forgetPasswordUseCase.invoke(emailController.text);
    either.fold((l) {
      isLoading = false;
      emit(ForgetPasswordErrorState(failure: l));
    }, (r) {
      isLoading = false;
      emit(ForgetPasswordSuccessState());
    });
  }

  //todo========================*( Animations )*=================

  late AnimationController animationController;
  late Animation<Offset> slideAnimation;
  double opacity = 0.0;

  void doAnimation(SingleTickerProviderStateMixin single) {
    animationController = AnimationController(
        vsync: single, duration: const Duration(seconds: 1));

    slideAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      opacity = 1.0;
      emit(ForgetPasswordAnimationState());

      animationController.forward();
    });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Features/login/domain/use_cases/login_use_case.dart';
import 'package:pesticides/Features/login/presentation/manager/states/login_states.dart';

@injectable
class LoginScreenViewModel extends Cubit<LoginStates> {
  LoginScreenViewModel({required this.loginUseCase})
      : super(LoginLoadingState());

  static LoginScreenViewModel get(context) =>
      BlocProvider.of<LoginScreenViewModel>(context);

  // Holding Data
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginUseCase loginUseCase;
  bool isLoaded = false;
  bool dialogShown = false;
  double opacity = 0.0;
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  // initialize animations
  void initializeAnimations(SingleTickerProviderStateMixin single) {
    animationController =
        AnimationController(vsync: single, duration: Duration(seconds: 1));

    slideAnimation =
        Tween<Offset>(begin: Offset(-1.w, 0), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      opacity = 1.0;
      emit(LoginViewModelAnimation());

      animationController.forward();
    });
  }

  // Handle login logic
  Future<void> login(String? type) async {
    isLoaded = true;
    emit(LoginLoadingState());
    var either = await loginUseCase.invoke(
        emailController.text, passwordController.text, type);
    either.fold((error) {
      isLoaded = false;
      emit(LoginErrorState(errorMsg: error.errorMessage));
    }, (user) {
      isLoaded = false;
      emit(LoginSuccessState());
      clearData();
    });
  }


  // Handle close logic
  void clearData() {
    emailController.clear();
    passwordController.clear();
    animationController.dispose();
  }

}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/login/domain/use_cases/login_use_case.dart';
import 'package:pesticides/Features/login/presentation/manager/states/login_states.dart';

@injectable
class LoginScreenViewModel extends Cubit<LoginStates> {
  LoginScreenViewModel({required this.loginUseCase})
      : super(LoginLoadingState());

  static LoginScreenViewModel get(context) =>
      BlocProvider.of<LoginScreenViewModel>(context);

  // Hold Data
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  LoginUseCase loginUseCase;
  late String? userType;
  bool isLoaded = false;
  double opacity = 0.0;
  late AnimationController animationController;
  late Animation<Offset> slideAnimation;

  void intializeAnimations(SingleTickerProviderStateMixin single) {
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
  void login(String? type) async {
    isLoaded = true;
      userType = type;
      emit(LoginLoadingState());

      try {
        var userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        if (userCredential.user != null) {
          var either = await loginUseCase.invoke(
              userType!, userCredential.user?.email ?? "");
          either.fold(
            (failure) => emit(LoginErrorState(errorMsg: failure.errorMessage)),
            (user) => emit(LoginSuccessState()),
          );
        } else {
          isLoaded = false;
          emit(LoginErrorState(errorMsg: "Login failed. User not found."));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == StringManager.userNotFound) {
          isLoaded = false;
          emit(LoginErrorState(errorMsg: "No user found for that email."));
        } else if (e.code == 'invalid-credential') {
          emit(LoginErrorState(errorMsg: StringManager.wrongPassword));
        } else {
          emit(LoginErrorState(errorMsg: "Internet connection lost"));
        }
      } catch (e) {
        isLoaded = false;
        emit(LoginErrorState(errorMsg: e.toString()));
      }

    @override
    Future<void> close() {
      emailController.dispose();
      passwordController.dispose();
      animationController.dispose();

      return super.close();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/component/button_custom.dart';
import 'package:pesticides/Core/component/lottie_loading_widget.dart';
import 'package:pesticides/Core/component/text_feild_custom.dart';
import 'package:pesticides/Core/component/validators.dart';
import 'package:pesticides/Features/login/presentation/manager/cubit/login_screen_view_model.dart';
import 'package:pesticides/Features/login/presentation/manager/states/login_states.dart';
import '../../../../Core/component/custom_dialog.dart';
import '../../../../Core/utils/colors.dart';
import '../../../../Core/utils/images.dart';
import '../../../../Core/utils/strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late LoginScreenViewModel viewModel;
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    viewModel = LoginScreenViewModel.get(context);
    viewModel.initializeAnimations(this);
  }




  @override
  Widget build(BuildContext context) {
    String? type = ModalRoute.of(context)?.settings.arguments as String?;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: BlocConsumer<LoginScreenViewModel, LoginStates>(
        listener: (context, state) {
          if (state is LoginLoadingState) {
            viewModel.isLoaded = true;
          } else {
            viewModel.isLoaded = false;
          }
          if (state is LoginSuccessState && !viewModel.dialogShown) {
            viewModel.dialogShown = true;
            DialogUtils.showAlertDialog(
                context: context,
                title: StringManager.success,
                message: StringManager.loginSuccessfully,
                posActionTitle: StringManager.ok,
                posAction: () {
                  viewModel.dialogShown = false;
                  Navigator.pushNamedAndRemoveUntil(context,
                      RoutesManger.routeNameCategoryScreen, (route) => false);
                });
          } else if (state is LoginErrorState && !viewModel.dialogShown) {
            viewModel.dialogShown = true;
            DialogUtils.showAlertDialog(
                context: context,
                title: StringManager.failed,
                message: state.errorMsg,
                posActionTitle: StringManager.ok,
                posAction: () {
                  viewModel.dialogShown = false;
                });
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            opacity: 0.4,
            color: ColorManager.greyShade3,
            inAsyncCall: viewModel.isLoaded,
            progressIndicator: const LottieLoadingWidget(),
            child: Scaffold(
              body: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImageManager.background),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SafeArea(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Form(
                          key: _loginFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(height: 40.h),
                                  AnimatedOpacity(
                                    opacity: viewModel.opacity,
                                    duration: Duration(seconds: 2),
                                    curve: Curves.easeIn,
                                    child: Image.asset(
                                      ImageManager.logoTeam,
                                      height: 220.h,
                                      width: 400.w,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  AnimatedOpacity(
                                    duration: Duration(seconds: 2),
                                    opacity: viewModel.opacity,
                                    curve: Curves.easeIn,
                                    child: Padding(
                                      padding: EdgeInsets.only(bottom: 20.h),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context,
                                              RoutesManger
                                                  .routeNameEngOwnerScreen);
                                        },
                                        child: Column(
                                          children: [
                                            Text(
                                              type == null
                                                  ? "Please choose a role to login"
                                                  : (type == "admin"
                                                      ? "Login as an $type"
                                                      : "Login as a $type"),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                      color: type == null
                                                          ? ColorManager
                                                              .yellowColor
                                                          : Theme.of(context)
                                                              .textTheme
                                                              .titleSmall!
                                                              .color),
                                            ),
                                            if (type != null) ...[
                                              SizedBox(height: 8.h),
                                              Text(
                                                "Change",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      color: ColorManager
                                                          .yellowColor,
                                                    ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SlideTransition(
                                    position: viewModel.slideAnimation,
                                    child: CustomTextFormField(
                                      enable: type == null ? false : true,
                                      hint: "Email",
                                      validator: (val) =>
                                          AppValidators.validateEmail(val),
                                      controller: viewModel.emailController,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  SlideTransition(
                                    position: viewModel.slideAnimation,
                                    child: CustomTextFormField(
                                      enable: type == null ? false : true,
                                      hint: "Password",
                                      validator: (val) =>
                                          AppValidators.validatePassword(val),
                                      controller: viewModel.passwordController,
                                      isSecured: true,
                                    ),
                                  ),
                                  AnimatedOpacity(
                                    duration: Duration(seconds: 2),
                                    opacity: viewModel.opacity,
                                    curve: Curves.easeIn,
                                    child: Center(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context,
                                              RoutesManger
                                                  .routeNameForgotPassScreen);
                                        },
                                        child: Text(
                                          "Forgot Password?",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  SlideTransition(
                                    position: viewModel.slideAnimation,
                                    child: ButtonCustom(
                                      buttonName: "Login",
                                      enable: type == null ? false : true,
                                      onTap: () {
                                        if (_loginFormKey.currentState!
                                                .validate() ==
                                            true) {
                                          viewModel.login(type);
                                        }

                                        // Navigator.pushReplacementNamed(context,
                                        //     RoutesManger.routeNameCategoryScreen);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              AnimatedOpacity(
                                duration: Duration(seconds: 2),
                                opacity: viewModel.opacity,
                                curve: Curves.easeIn,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 100.h),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(context,
                                          RoutesManger.routeNameRegister);
                                    },
                                    child: Text(
                                      "Don't have an account? Sign Up",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

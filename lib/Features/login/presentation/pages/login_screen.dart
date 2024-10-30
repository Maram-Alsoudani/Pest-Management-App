import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/component/button_custom.dart';
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
  @override
  void initState() {
    super.initState();
    viewModel = LoginScreenViewModel.get(context);
    viewModel.isLoaded = false;
    viewModel.intializeAnimations(this);
  }

  //
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? type=ModalRoute.of(context)?.settings.arguments as String?;
    return SafeArea(
      child: BlocConsumer<LoginScreenViewModel, LoginStates>(
        listener: (context, state) {
          if (state is LoginLoadingState) {
            viewModel.isLoaded = true;
          } else {
            viewModel.isLoaded = false;
          }
          if (state is LoginSuccessState) {
            DialogUtils.showAlertDialog(
                context: context,
                title: StringManager.success,
                message: StringManager.loginSuccessfully,
                posActionTitle: StringManager.ok,
                posAction: () {
                  Navigator.pushReplacementNamed(
                      context, RoutesManger.routeNameCategoryScreen);
                });
          } else if (state is LoginErrorState) {
            DialogUtils.showAlertDialog(
              context: context,
              title: StringManager.failed,
              message: state.errorMsg,
              posActionTitle: StringManager.ok,
            );
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            opacity: 0.2,
            color: ColorManager.greyShade3,
            inAsyncCall: viewModel.isLoaded,
            progressIndicator: Center(
              child: CircularProgressIndicator(
                color: ColorManager.primaryColor,
              ),
            ),
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
                  SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Form(
                        key: viewModel.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height: 80.h),
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
                                      child: Text(
                                          "Type: ${type ?? "Select Type Please "} ? Change From Here",
                                          style: type == null
                                              ? Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .copyWith(
                                                      color: ColorManager
                                                          .yellowColor)
                                              : Theme.of(context)
                                                  .textTheme
                                                  .titleSmall),
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context,
                                              RoutesManger
                                                  .routeNameForgotPassScreen);
                                        },
                                        child: Text(
                                          "Forgot Password?",
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                SlideTransition(
                                  position: viewModel.slideAnimation,
                                  child: ButtonCustom(
                                    buttonName: "Login",
                                    enable: type == null ? false : true,
                                    onTap: () {
                                      viewModel.login(type);
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
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(context,
                                        RoutesManger.routeNameRegister);
                                  },
                                  child: Text(
                                    "Don't have an account? Sign Up Here",
                                    style:
                                        Theme
                                        .of(context)
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bug_away/Core/component/button_custom.dart';
import 'package:bug_away/Core/component/text_feild_custom.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/images.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/forgotPassword/presentation/manager/forget_password_state.dart';
import 'package:bug_away/Features/forgotPassword/presentation/manager/forget_password_view_model.dart';
import 'package:bug_away/di/di.dart';

import '../../../../Core/component/custom_dialog.dart';
import '../../../../Core/component/lottie_loading_widget.dart';
import '../../../../Core/component/validators.dart';

class ForgotPassScreen extends StatefulWidget {
  ForgotPassScreen({super.key});
  ForgetPasswordViewModel viewModel = getIt<ForgetPasswordViewModel>();

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    ForgetPasswordViewModel.get(context).doAnimation(this);
  }

  @override
  Widget build(BuildContext context) {
    ForgetPasswordViewModel.get(context).opacity = 0.0;
    return BlocConsumer<ForgetPasswordViewModel, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordErrorState) {
          DialogUtils.showAlertDialog(
              context: context,
              title: StringManager.error,
              message: state.failure.errorMessage,
              posActionTitle: StringManager.ok);
        } else if (state is ForgetPasswordSuccessState) {
          DialogUtils.showAlertDialog(
              context: context,
              title: StringManager.success,
              message: StringManager.passwordResetSuccess,
              posActionTitle: StringManager.ok);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageManager.background),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ModalProgressHUD(
              opacity: 0.4,
              color: ColorManager.greyShade3,
              inAsyncCall: ForgetPasswordViewModel.get(context).isLoading,
              progressIndicator: const LottieLoadingWidget(),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 30),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: 50.h,
                        ),
                        AnimatedOpacity(
                          duration: const Duration(seconds: 2),
                          opacity: ForgetPasswordViewModel.get(context).opacity,
                          curve: Curves.easeIn,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                StringManager.forgotPass,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: ColorManager.whiteColor,
                                        fontSize: 30),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(StringManager.resetPassEmail,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          color: ColorManager.greyShade2,
                                          fontSize: 15)),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 80.h,
                        ),
                        SlideTransition(
                          position: ForgetPasswordViewModel.get(context)
                              .slideAnimation,
                          child: Form(
                            key: ForgetPasswordViewModel.get(context)
                                .forgetPasswordFormKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: CustomTextFormField(
                                      hint: StringManager.email,
                                      validator: (val) =>
                                          AppValidators.validateEmail(val),
                                      controller:
                                          ForgetPasswordViewModel.get(context)
                                              .emailController,
                                    )),
                                ButtonCustom(
                                  buttonName: StringManager.send,
                                  enable: true,
                                  onTap: () {
                                    if (ForgetPasswordViewModel.get(context)
                                        .forgetPasswordFormKey
                                        .currentState!
                                        .validate()) {
                                      ForgetPasswordViewModel.get(context)
                                          .forgetPassword();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),
                        AnimatedOpacity(
                          duration: const Duration(seconds: 2),
                          opacity: ForgetPasswordViewModel.get(context).opacity,
                          curve: Curves.easeIn,
                          child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                  "${StringManager.alreadyHaveAccount} ${StringManager.login} ",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        color: ColorManager.whiteColor,
                                      ))),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

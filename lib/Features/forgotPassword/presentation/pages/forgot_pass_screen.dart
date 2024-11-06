import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/component/button_custom.dart';
import 'package:pesticides/Core/component/text_feild_custom.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/eng_owner_screen/presentation/widget/custom_button.dart';
import 'package:pesticides/Features/forgotPassword/presentation/manager/forget_password_state.dart';
import 'package:pesticides/Features/forgotPassword/presentation/manager/forget_password_view_model.dart';
import 'package:pesticides/di/di.dart';

import '../../../../Core/component/custom_dialog.dart';
import '../../../../Core/component/validators.dart';

class ForgotPassScreen extends StatefulWidget {
   ForgotPassScreen({super.key});
  ForgetPasswordViewModel viewModel = getIt<ForgetPasswordViewModel>();

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  double _opacity = 0.0;
  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _slideAnimation =
        Tween<Offset>(begin: Offset(-1.w, 0), end: const Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Trigger the slide animation after the page loads
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });

      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordViewModel , ForgetPasswordState>(
      bloc: widget.viewModel,
      listener: (context , state){
        if(state is ForgetPasswordErrorState){
          DialogUtils.showAlertDialog(
              context: context,
              title: StringManager.error,
              message: state.failure.errorMessage,
              posActionTitle: StringManager.ok);
        }else if(state is ForgetPasswordSuccessState){
          DialogUtils.showAlertDialog(
              context: context,
              title: StringManager.success,
              message: StringManager.passwordRestSuccessfully,
              posActionTitle: StringManager.ok);
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedOpacity(
                duration: const Duration(seconds: 2),
                opacity: _opacity,
                curve: Curves.easeIn,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      StringManager.forgotPass,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: ColorManager.whiteColor, fontSize: 30),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(StringManager.enterEmailForResetPass,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: ColorManager.greyShade2, fontSize: 15)),
                  ],
                ),
              ),
              SizedBox(
                height: 80,
              ),
              SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CustomTextFormField(
                          hint: "Email",
                          validator: (val) => AppValidators.validateEmail(val),
                          controller: widget.viewModel.emailController,
                        )),
                    ButtonCustom(
                      buttonName: "Send",
                      enable: true,
                      onTap: () {widget.viewModel.forgetPassword();},
                    )
                  ],
                ),
              ),
              Spacer(),
              AnimatedOpacity(
                duration: const Duration(seconds: 2),
                opacity: _opacity,
                curve: Curves.easeIn,
                child: TextButton(
                    onPressed: () {

                      Navigator.pop(context);
                    },
                    child: Text("${StringManager.already_have_an_account} Login",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: ColorManager.whiteColor,
                            ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}

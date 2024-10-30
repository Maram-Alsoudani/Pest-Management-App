import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/component/button_custom.dart';
import 'package:pesticides/Core/component/custom_dialog.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/images.dart';
import 'package:pesticides/Core/utils/strings.dart';

import '../../../../Core/component/drop_down_menu_widget.dart';
import '../../../../Core/component/text_feild_custom.dart';
import '../../../../Core/component/validators.dart';
import '../manager/register_view_model_cubit.dart';
import '../widgets/pick_image_widget.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late RegisterViewModelCubit bloc;
  @override
  void initState() {
    super.initState();
    bloc = RegisterViewModelCubit.get(context);
    bloc.doAnimation(this);
    bloc.initValueDropDown();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<RegisterViewModelCubit, RegisterViewModelState>(
        listener: (context, state) {
          if (state is RegisterViewModelSuccess) {
            DialogUtils.showAlertDialog(
                context: context,
                title: StringManager.success,
                message: StringManager.registerSuccessfully,
              posActionTitle: StringManager.ok,
            );
          } else if (state is RegisterViewModelError) {
            DialogUtils.showAlertDialog(
              context: context,
              title: StringManager.failed,
              message: state.failure.errorMessage,
              posActionTitle: StringManager.ok,
            );
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            opacity: 0.2,
            color: ColorManager.greyShade3,
            inAsyncCall: bloc.isLoaded,
            progressIndicator: Center(
              child: CircularProgressIndicator(
                color: ColorManager.primaryColor,
              ),
            ),
            child: Scaffold(
              body: Stack(
                children: [
                  // Background image
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImageManager
                            .background), // Replace with your image path
                        fit: BoxFit.cover, // Cover the entire screen
                      ),
                    ),
                  ),

                  SingleChildScrollView(
                    child: Form(
                      key: bloc.fromKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 30.h),
                          AnimatedOpacity(
                            duration: const Duration(seconds: 2),
                            opacity: bloc.opacity,
                            curve: Curves.easeIn,
                            child: PickImageWidget(
                              icon: Icons.add_a_photo,
                            ),
                          ),
                          SizedBox(height: 18.h),
                          SlideTransition(
                            position: bloc.slideAnimation,
                            child: DropDownMenuWidget(
                              list: bloc.list,
                              selectedValue: bloc.selectedValue,
                              onChange: (String? value) {
                                bloc.selectedValue = value;
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SlideTransition(
                            position: bloc.slideAnimation,
                            child: CustomTextFormField(
                              hint: StringManager.userName,
                              validator: (val) =>
                                  AppValidators.validateUsername(val),
                              controller: bloc.userNameController,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SlideTransition(
                            position: bloc.slideAnimation,
                            child: CustomTextFormField(
                              hint: StringManager.phone,
                              validator: (val) =>
                                  AppValidators.validatePhoneNumber(val),
                              controller: bloc.phoneController,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SlideTransition(
                            position: bloc.slideAnimation,
                            child: CustomTextFormField(
                              hint: StringManager.email,
                              validator: (val) =>
                                  AppValidators.validateEmail(val),
                              controller: bloc.emailController,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SlideTransition(
                            position: bloc.slideAnimation,
                            child: CustomTextFormField(
                              hint: StringManager.password,
                              validator: (val) =>
                                  AppValidators.validatePassword(val),
                              controller: bloc.passwordController,
                              isSecured: true,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SlideTransition(
                            position: bloc.slideAnimation,
                            child: CustomTextFormField(
                              hint: StringManager.confirmPassword,
                              validator: (val) =>
                                  AppValidators.validateConfirmPassword(
                                      val, bloc.passwordController.text),
                              controller: bloc.confirmPasswordController,
                              isSecured: true,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          SlideTransition(
                            position: bloc.slideAnimation,
                            child: ButtonCustom(
                              buttonName: StringManager.register,
                              onTap: () {
                                if (bloc.fromKey.currentState!.validate()) {
                                  bloc.register();
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 15.h),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                RoutesManger.routeNameLogin,
                              );
                            },
                            child: AnimatedOpacity(
                              duration: const Duration(seconds: 2),
                              opacity: bloc.opacity,
                              curve: Curves.easeIn,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    StringManager.already_have_an_account,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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

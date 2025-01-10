import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bug_away/Core/component/button_custom.dart';
import 'package:bug_away/Core/component/custom_dialog.dart';
import 'package:bug_away/Core/component/lottie_loading_widget.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/images.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Core/component/show_model_picker_image.dart';

import '../../../../Core/component/drop_down_menu_widget.dart';
import '../../../../Core/component/text_feild_custom.dart';
import '../../../../Core/component/validators.dart';
import '../manager/user_request_account_view_model_cubit.dart';
import '../widgets/pick_Image_widget.dart';

class UserRequestAccount extends StatefulWidget {
  const UserRequestAccount({super.key});

  @override
  State<UserRequestAccount> createState() => _UserRequestAccountState();
}

class _UserRequestAccountState extends State<UserRequestAccount>
    with SingleTickerProviderStateMixin {
  late UserRequestAccountCubit bloc;

  @override
  void initState() {
    super.initState();
    bloc = UserRequestAccountCubit.get(context);
    bloc.doAnimation(this);
    bloc.initValueDropDown();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserRequestAccountCubit, UserRequestAccountState>(
      listener: (context, state) {
        if (state is UserRequestAccountViewModelSuccess) {
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.success,
            message: StringManager.requestSuccess,
            posActionTitle: StringManager.ok,
          );
        } else if (state is UserRequestAccountViewModelError) {
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
            opacity: 0.4,
            color: ColorManager.greyShade3,
            inAsyncCall: bloc.isLoaded,
            progressIndicator: const Center(child: LottieLoadingWidget()),
            child: Stack(
              children: [
                // Background image
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

                Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                  ),
                  body: SingleChildScrollView(
                    child: Form(
                      key: bloc.fromKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(seconds: 2),
                            opacity: bloc.opacity,
                            curve: Curves.easeIn,
                            child: Center(
                              child: GestureDetector(
                                onTap: bloc.image == null
                                    ? null
                                    : _showImagePickerDialog,
                                child: PickImageWidgetRegister(
                                  imagePath: bloc.image,
                                  icon: Icons.add_a_photo,
                                  onImagePicked: bloc.pickImage,
                                ),
                              ),
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
                              buttonName: StringManager.requestAccount,
                              onTap: () async {
                                if (bloc.fromKey.currentState!.validate()) {
                                  bloc.userRequestAccount();
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 15.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  void _showImagePickerDialog() {
    if (Platform.isIOS || Platform.isMacOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.transparent,
            clipBehavior: Clip.none,
            child: ShowModelPickerImage(
              uploadImage2Screen: bloc.pickImage,
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ShowModelPickerImage(uploadImage2Screen: bloc.pickImage);
        },
      );
    }
  }
}

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/component/button_custom.dart';
import 'package:pesticides/Core/component/validators.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/images.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/category/profile/presentation/widgets/build_info_card.dart';
import 'package:pesticides/Features/category/profile/presentation/widgets/pick_image_widget.dart';
import 'package:pesticides/Core/component/custom_dialog.dart';
import 'package:pesticides/Features/category/presentation/manager/category_cubit.dart';

import '../../../../../Core/component/text_feild_custom.dart';
import '../manager/profile_cubit.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final fromKey = GlobalKey<FormState>();
  final dialogFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<ProfileCubit>(context, listen: true);
    return Scaffold(
      body: Stack(
        children: [
          // Background container with image
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
          SafeArea(
            child: SingleChildScrollView(
              child: BlocBuilder<CategoryCubit, CategoryState>(
                builder: (context, state) {
                  return Form(
                    key: fromKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 65.h),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            PickImageWidget(
                              icon: Icons.add_a_photo,
                              imageUrl: cubit.userProfileImage?.isNotEmpty ==
                                      true
                                  ? cubit.userProfileImage
                                  : 'path_to_fallback_image', // Handle empty or null URL
                              imagePath: cubit.image,
                              onImagePicked: cubit.pickImage,
                            ),
                          ],
                        ),
                        SizedBox(height: 35.h),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: ListView(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              BuildInfoCard(
                                title: StringManager.role,
                                value: cubit.typeController.text,
                              ),
                              BuildInfoCard(
                                title: StringManager.userName,
                                value: cubit.userNameController.text,
                              ),
                              BuildInfoCard(
                                title: StringManager.phone,
                                value: cubit.phoneController.text,
                              ),
                              BuildInfoCard(
                                title: StringManager.email,
                                value: cubit.emailController.text,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 13.w, vertical: 10.h),
                                child: ButtonCustom(
                                  buttonName: "Edit",
                                  onTap: () {
                                    if (fromKey.currentState!.validate()) {
                                      _showEditDialog(context, cubit);
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(CupertinoIcons.back,
                        color: ColorManager.whiteColor),
                  ),
                  IconButton(
                    onPressed: () {
                      DialogUtils.showAlertDialog(
                        context: context,
                        title: StringManager.logout,
                        message: StringManager.logoutMessage,
                        posActionTitle: StringManager.yes,
                        negActionTitle: StringManager.no,
                        posAction: () {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            RoutesManger.routeNameLogin,
                            (route) => false,
                          );
                        },
                      );
                    },
                    icon: const Icon(CupertinoIcons.square_arrow_right,
                        color: ColorManager.whiteColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to show dialog with editable fields and validation
  void _showEditDialog(BuildContext context, ProfileCubit cubit) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: ColorManager.backgroundColor,
          title: Text(
            'Edit Profile',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontSize: 24.sp),
          ),
          content: Form(
            key: dialogFormKey, // Assign the dialog-specific form key here
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8.h),
                CustomTextFormField(
                  hint: StringManager.userName,
                  validator: (val) => AppValidators.validateUsername(val),
                  controller: cubit.userNameController,
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  hint: StringManager.phone,
                  validator: (val) => AppValidators.validatePhoneNumber(val),
                  controller: cubit.phoneController,
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:
                  Text('Cancel', style: Theme.of(context).textTheme.titleSmall),
            ),
            ButtonCustom(
              buttonName: "Save",
              onTap: () {
                // Validate the dialog form before proceeding
                if (dialogFormKey.currentState!.validate()) {
                  cubit.editDataUser(); // Update user data
                  Navigator.pop(context); // Close dialog
                }
              },
            ),
          ],
        );
      },
    );
  }
}

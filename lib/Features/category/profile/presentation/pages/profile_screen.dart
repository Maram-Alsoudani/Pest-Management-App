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
import 'package:pesticides/Features/category/profile/presentation/manager/profile_state.dart';
import 'package:pesticides/Features/category/profile/presentation/widgets/build_info_card.dart';
import 'package:pesticides/Features/category/profile/presentation/widgets/edit_profile_dialog.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      bloc: ProfileCubit.get(context),
      builder: (context, state) {
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
                        key: ProfileCubit.get(context).fromKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: 65.h),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                PickImageWidget(
                                  icon: Icons.add_a_photo,
                                  imageUrl: ProfileCubit.get(context)
                                              .userProfileImage
                                              ?.isNotEmpty ==
                                          true
                                      ? ProfileCubit.get(context)
                                          .userProfileImage
                                      : 'path_to_fallback_image', // Handle empty or null URL
                                  imagePath: ProfileCubit.get(context).image,
                                  onImagePicked:
                                      ProfileCubit.get(context).pickImage,
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
                                    value: ProfileCubit.get(context)
                                        .typeController
                                        .text,
                                  ),
                                  BuildInfoCard(
                                    title: StringManager.userName,
                                    value: ProfileCubit.get(context)
                                        .userNameController
                                        .text,
                                  ),
                                  BuildInfoCard(
                                    title: StringManager.phone,
                                    value: ProfileCubit.get(context)
                                        .phoneController
                                        .text,
                                  ),
                                  BuildInfoCard(
                                    title: StringManager.email,
                                    value: ProfileCubit.get(context)
                                        .emailController
                                        .text,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 13.w, vertical: 10.h),
                                    child: ButtonCustom(
                                        buttonName: StringManager.edit,
                                        onTap: () {
                                          //todo Function to show dialog with editable fields and validation
                                          if (ProfileCubit.get(context)
                                              .fromKey
                                              .currentState!
                                              .validate()) {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return EditProfileDialog();
                                                });
                                          }
                                        }),
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
      },
    );
  }
}

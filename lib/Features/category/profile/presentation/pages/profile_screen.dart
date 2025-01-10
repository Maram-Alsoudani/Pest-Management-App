import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bug_away/Config/routes/routes_manger.dart';
import 'package:bug_away/Core/component/button_custom.dart';
import 'package:bug_away/Core/component/lottie_loading_widget.dart';
import 'package:bug_away/Core/component/validators.dart';
import 'package:bug_away/Core/utils/SharedPrefsLocal.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/images.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/category/profile/presentation/manager/profile_cubit.dart';
import 'package:bug_away/Features/category/profile/presentation/manager/profile_state.dart';
import 'package:bug_away/Features/category/profile/presentation/widgets/build_info_card.dart';
import 'package:bug_away/Features/category/profile/presentation/widgets/edit_profile_dialog.dart';
import 'package:bug_away/Features/category/profile/presentation/widgets/pick_image_widget.dart';
import 'package:bug_away/Core/component/custom_dialog.dart';
import 'package:bug_away/Features/category/presentation/manager/category_cubit.dart';

import '../../../../register/data/models/user_model_dto.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    ProfileCubit.get(context).getUserData();
    ProfileCubit.get(context).doAnimation(this);
    ProfileCubit.get(context).getUser();
    ProfileCubit.get(context).opacity = 0.0;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.failed,
            message: state.error.errorMessage,
            posActionTitle: StringManager.ok,
          );
        } else if (state is ProfileLogOutError) {
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.failed,
            message: state.error.errorMessage,
            posActionTitle: StringManager.ok,
          );
        } else if (state is ProfileUpdateSuccess) {
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.success,
            message: StringManager.saveSuccess,
            posActionTitle: StringManager.ok,
          );
        } else if (state is ProfileUpdateSuccess) {
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.success,
            message: StringManager.saveSuccess,
            posActionTitle: StringManager.ok,
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          opacity: 0.4,
          color: ColorManager.greyShade3,
          inAsyncCall: ProfileCubit.get(context).isLoading,
          progressIndicator: const Center(child: LottieLoadingWidget()),
          child: Scaffold(
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
                  child: BlocBuilder<CategoryCubit, CategoryState>(
                    builder: (context, state) {
                      return Form(
                        key: ProfileCubit.get(context).fromKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 65.h),
                              AnimatedOpacity(
                                duration: const Duration(seconds: 2),
                                opacity: ProfileCubit.get(context).opacity,
                                curve: Curves.easeIn,
                                child: Stack(
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
                                          : '',
                                      imagePath:
                                          ProfileCubit.get(context).image,
                                      onImagePicked:
                                          ProfileCubit.get(context).pickImage,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 35.h),
                              SlideTransition(
                                position:
                                    ProfileCubit.get(context).slideAnimation,
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.6,
                                  child: ListView(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      BuildInfoCard(
                                        title: StringManager.role,
                                        value: ProfileCubit.get(context)
                                            .typeController
                                            .text,
                                      ),
                                      BuildInfoCard(
                                        icon: const FaIcon(
                                            FontAwesomeIcons.userLarge),
                                        title: StringManager.userName,
                                        value: ProfileCubit.get(context)
                                            .userNameController
                                            .text,
                                      ),
                                      BuildInfoCard(
                                        title: StringManager.phone,
                                        icon: const FaIcon(
                                            FontAwesomeIcons.phone),
                                        value: ProfileCubit.get(context)
                                            .phoneController
                                            .text,
                                      ),
                                      BuildInfoCard(
                                        icon: const FaIcon(FontAwesomeIcons.at),
                                        title: StringManager.email,
                                        value: ProfileCubit.get(context)
                                            .emailController
                                            .text,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 13.w, vertical: 2.h),
                                        child: ButtonCustom(
                                            buttonName: StringManager.edit,
                                            onTap: () {
                                              if (ProfileCubit.get(context)
                                                  .fromKey
                                                  .currentState!
                                                  .validate()) {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return const EditProfileDialog();
                                                    });
                                              }
                                            }),
                                      ),
                                      ProfileCubit.get(context).user!.type ==
                                              UserAndAdminModelDto.admin
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 13.w,
                                                  vertical: 2.h),
                                              child: ButtonCustom(
                                                  buttonName:
                                                      StringManager.addAccount,
                                                  onTap: () {
                                                    if (ProfileCubit.get(
                                                            context)
                                                        .fromKey
                                                        .currentState!
                                                        .validate()) {
                                                      Navigator.pushNamed(
                                                          context,
                                                          RoutesManger
                                                              .routeNameRegister);
                                                    }
                                                  }),
                                            )
                                          : const SizedBox(
                                              height: 10,
                                            )
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
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              RoutesManger.routeNameCategoryScreen,
                            );
                            ProfileCubit.get(context).clearData();
                          },
                          icon: const FaIcon(FontAwesomeIcons.chevronLeft,
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
                              posAction: () async {
                                await ProfileCubit.get(context).removeFcmUser();
                                SharedPrefsLocal.prefs.clear();
                                FirebaseAuth.instance.signOut();
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RoutesManger.routeNameEngOwnerScreen,
                                  (route) => false,
                                );
                              },
                            );
                          },
                          icon: const FaIcon(
                              FontAwesomeIcons.arrowRightFromBracket,
                              color: ColorManager.whiteColor),
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
    );
  }
}

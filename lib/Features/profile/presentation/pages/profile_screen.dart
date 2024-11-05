import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/component/lottie_loading_widget.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/images.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Core/component/pick_image_widget.dart';
import 'package:pesticides/Core/component/show_model_picker_image.dart';
import 'package:pesticides/Core/component/custom_dialog.dart';
import 'package:pesticides/Features/profile/presentation/manager/profile_cubit.dart';
import 'package:pesticides/Features/profile/presentation/manager/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: Scaffold(
        body: Stack(
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
            SafeArea(
              child: SingleChildScrollView(
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    final cubit = context.read<ProfileCubit>();
                    return Form(
                      key: cubit.fromKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 65.h),
                          GestureDetector(
                            onTap: () => _showImagePickerDialog(context, cubit),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                PickImageWidget(
                                  icon: Icons.add_a_photo,
                                  imageUrl: cubit.userProfileImage,
                                  onImagePicked: cubit.pickImage,
                                ),
                                if (state is ProfileUploading)
                                  const LottieLoadingWidget(),
                              ],
                            ),
                          ),
                          SizedBox(height: 35.h),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                Card(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 20.w),
                                  child: ListTile(
                                    leading: const Icon(CupertinoIcons.info,
                                        color: ColorManager.primaryColor),
                                    title: const Text(StringManager.role),
                                    subtitle: Text(
                                      cubit.typeController.text == 'user'
                                          ? 'Engineer'
                                          : cubit.typeController.text == 'admin'
                                              ? 'Admin'
                                              : cubit.typeController.text,
                                    ),
                                  ),
                                ),
                                Card(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 20.w),
                                  child: ListTile(
                                    leading: const Icon(CupertinoIcons.person,
                                        color: ColorManager.primaryColor),
                                    title: const Text(StringManager.userName),
                                    subtitle:
                                        Text(cubit.userNameController.text),
                                  ),
                                ),
                                Card(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 20.w),
                                  child: ListTile(
                                    leading: const Icon(CupertinoIcons.phone,
                                        color: ColorManager.primaryColor),
                                    title: const Text(StringManager.phone),
                                    subtitle: Text(cubit.phoneController.text),
                                  ),
                                ),
                                Card(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 20.w),
                                  child: ListTile(
                                    leading: const Icon(CupertinoIcons.mail,
                                        color: ColorManager.primaryColor),
                                    title: const Text(StringManager.email),
                                    subtitle: Text(cubit.emailController.text),
                                  ),
                                ),
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        CupertinoIcons.back,
                        color: ColorManager.whiteColor,
                      ),
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
                            });
                      },
                      icon: const Icon(
                        CupertinoIcons.square_arrow_right,
                        color: ColorManager.whiteColor,
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
  }

  void _showImagePickerDialog(BuildContext context, ProfileCubit cubit) {
    if (Platform.isIOS || Platform.isMacOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.transparent,
            child: ShowModelPickerImage(
              uploadImage2Screen: cubit.pickImage,
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ShowModelPickerImage(
            uploadImage2Screen: cubit.pickImage,
          );
        },
      );
    }
  }
}

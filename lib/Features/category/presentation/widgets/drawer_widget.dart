import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Config/routes/routes_manger.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Core/utils/font_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../Core/component/image_profile.dart';
import '../../../../Core/utils/images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bug_away/Core/utils/SharedPrefsLocal.dart';

import '../../profile/presentation/manager/profile_cubit.dart';

class DrawerWidget extends StatelessWidget {
  final String userName;
  final String? userImage;
  final String userType;

  const DrawerWidget({
    super.key,
    required this.userName,
    this.userImage,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageManager.background),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  userImage != null && userImage!.isNotEmpty
                      ? ClipOval(
                          child: CachedNetworkImage(
                            width: 100.w,
                            height: 100.h,
                            fit: BoxFit.cover,
                            imageUrl: userImage!,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                                        color: ColorManager.primaryColor,
                                        value: downloadProgress.progress),
                            errorWidget: (context, url, error) =>
                                ImageProfile(radius: 40.r),
                          ),
                        )
                      : ImageProfile(radius: 40.r),
                  SizedBox(width: 10.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontSize: FontSize.s24.sp,
                              color: Colors.white,
                            ),
                      ),
                      SizedBox(height: 5.h),
                      Center(
                        child: Text(
                          userType,
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.account_circle,
                              color: ColorManager.whiteColor),
                          title: const Text(
                            StringManager.profile,
                            style: TextStyle(
                              color: ColorManager.whiteColor,
                              fontFamily: FontConstants.fontFamily,
                              fontWeight: FontWeightManager.regular,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutesManger.routeNameProfile);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.message,
                              color: ColorManager.whiteColor),
                          title: const Text(
                            StringManager.messages,
                            style: TextStyle(
                              color: ColorManager.whiteColor,
                              fontFamily: FontConstants.fontFamily,
                              fontWeight: FontWeightManager.regular,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutesManger.routeNameChat);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.admin_panel_settings,
                              color: ColorManager.whiteColor),
                          title: const Text(
                            StringManager.accountRequests,
                            style: TextStyle(
                              color: ColorManager.whiteColor,
                              fontFamily: FontConstants.fontFamily,
                              fontWeight: FontWeightManager.regular,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                                context, RoutesManger.routeNameRequiest);
                          },
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout,
                        color: ColorManager.whiteColor),
                    title: const Text(
                      StringManager.logout,
                      style: TextStyle(
                        color: ColorManager.whiteColor,
                        fontFamily: FontConstants.fontFamily,
                        fontWeight: FontWeightManager.regular,
                      ),
                    ),
                    onTap: () async {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RoutesManger.routeNameEngOwnerScreen,
                        (route) => false,
                      );
                      await ProfileCubit.get(context).removeFcmUser();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

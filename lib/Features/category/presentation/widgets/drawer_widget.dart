import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Config/routes/routes_manger.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Core/utils/font_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bug_away/Core/utils/SharedPrefsLocal.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../Core/component/image_profile.dart';
import '../../../../Core/utils/images.dart';
import '../../profile/presentation/manager/profile_cubit.dart';
import '../../../../Core/component/custom_dialog.dart'; // Import the custom dialog

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
            image: AssetImage(
              ImageManager.drawerBackground,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            _buildDrawerHeader(context),
            const Divider(
                color: ColorManager.greyShade4, endIndent: 40, indent: 40),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildListTile(
                    context,
                    icon: FontAwesomeIcons.solidCircleUser,
                    title: StringManager.profile,
                    routeName: RoutesManger.routeNameProfile,
                  ),
                  _buildDivider(),
                  _buildListTile(
                    context,
                    icon: FontAwesomeIcons.solidComments,
                    title: StringManager.messages,
                    routeName: RoutesManger.routeNameChat,
                  ),
                  _buildDivider(),
                  if (userType.toLowerCase() == 'admin') ...[
                    _buildListTile(
                      context,
                      icon: FontAwesomeIcons.solidAddressCard,
                      title: StringManager.accountRequests,
                      routeName: RoutesManger.routeNameRequiest,
                    ),
                    _buildDivider(),
                  ],
                ],
              ),
            ),
            _buildDivider(),
            _buildListTile(
              context,
              icon: FontAwesomeIcons.arrowRightFromBracket,
              title: StringManager.logout,
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
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
                                value: downloadProgress.progress),
                    errorWidget: (context, url, error) =>
                        ImageProfile(radius: 40.r),
                  ),
                )
              : ImageProfile(radius: 40.r),
          SizedBox(width: 10.w),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  userName,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 20.sp,
                        color: ColorManager.whiteColor,
                      ),
                ),
                SizedBox(height: 5.h),
                Text(
                  getDisplayUserType(userType),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: 16.sp,
                        color: ColorManager.whiteColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
      required String title,
      String? routeName,
      VoidCallback? onTap}) {
    return ListTile(
      leading: FaIcon(icon, color: ColorManager.whiteColor),
      title: Text(
        title,
        style: const TextStyle(
          color: ColorManager.whiteColor,
          fontFamily: FontConstants.fontFamily,
          fontWeight: FontWeightManager.regular,
        ),
      ),
      onTap: onTap ??
          () {
            if (routeName != null) {
              Navigator.pushNamed(context, routeName);
            }
          },
    );
  }

  Widget _buildDivider() {
    return const Divider(
        color: ColorManager.greyShade4, endIndent: 40, indent: 40);
  }

  void _showLogoutDialog(BuildContext context) {
    DialogUtils.showAlertDialog(
      context: context,
      title: StringManager.logout,
      message: StringManager.logoutMessage,
      posActionTitle: StringManager.ok,
      negActionTitle: StringManager.cancel,
      posAction: () async {
        await ProfileCubit.get(context).removeFcmUser();
        SharedPrefsLocal.prefs.clear();
        FirebaseAuth.instance.signOut();
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesManger.routeNameLogin,
          (route) => false,
        );
      },
    );
  }
}

String getDisplayUserType(String userType) {
  switch (userType.toLowerCase()) {
    case 'admin':
      return 'Admin';
    case 'user':
      return 'Engineer';
    default:
      return userType;
  }
}

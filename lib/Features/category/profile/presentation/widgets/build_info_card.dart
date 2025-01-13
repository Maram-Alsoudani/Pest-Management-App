import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../Core/utils/colors.dart';

class BuildInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final FaIcon? icon;

  const BuildInfoCard({
    super.key,
    required this.title,
    required this.value,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: icon != null
                ? FaIcon(icon!.icon,
                    color: icon!.color ?? ColorManager.primaryColor)
                : const FaIcon(FontAwesomeIcons.solidIdBadge,
                    color: ColorManager.primaryColor),
          ),
          title: Text(
            "$title:",
            style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            value,
            style: TextStyle(
                fontSize: 15.sp,
                color: ColorManager.greyShade5,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

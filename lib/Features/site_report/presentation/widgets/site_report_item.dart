import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/colors.dart';

class SiteReportItemContainer extends StatelessWidget {
  final String title;
  final VoidCallback onClicked;
  final IconData icon;

  const SiteReportItemContainer({
    super.key,
    required this.title,
    required this.onClicked,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0.r, vertical: 10.0.r),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22.0.r),
        ),
        elevation: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22.0.r),
          child: Container(
            color: ColorManager.whiteColor,
            child: ListTile(
              leading: Icon(
                icon,
                color: ColorManager.primaryColor,
              ),
              title: Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: ColorManager.blackColor,
                    ),
              ),
              trailing: const Icon(
                CupertinoIcons.chevron_right,
                color: ColorManager.blackColor,
              ),
              onTap: onClicked,
            ),
          ),
        ),
      ),
    );
  }
}

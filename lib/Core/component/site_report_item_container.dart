import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/colors.dart';

class SiteReportItemContainer extends StatelessWidget {
  String title;
  void Function() onClicked;

  SiteReportItemContainer(
      {super.key, required this.title, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
            color: ColorManager.whiteColor,
            borderRadius: BorderRadius.circular(20.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            IconButton(
                onPressed: onClicked,
                icon: Icon(
                  Icons.arrow_forward_ios,
                  size: 30.sp,
                  color: ColorManager.primaryColor,
                ))
          ],
        ),
      ),
    );
  }
}

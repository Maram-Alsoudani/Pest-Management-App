import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/strings.dart';

import '../../../../Core/utils/colors.dart';

class SiteWidget extends StatelessWidget {
  final String siteName;
  final String siteLocation;

  const SiteWidget(
      {super.key, required this.siteName, required this.siteLocation});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 80,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: ColorManager.whiteColor,
          borderRadius: BorderRadius.circular(20.sp)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                siteName,
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 5.h,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: ColorManager.primaryColor,
                    size: 20.sp,
                  ),
                  Text(
                    siteLocation,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: ColorManager.greyShade4,
                        ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            StringManager.view,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: ColorManager.redColor,
                ),
          ),
        ],
      ),
    );
  }
}

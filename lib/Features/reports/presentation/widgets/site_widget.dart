import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Core/utils/colors.dart';

class SiteWidget extends StatelessWidget {
  final String siteName;
  final String siteLocation;
  final VoidCallback onClicked;

  const SiteWidget({
    super.key,
    required this.siteName,
    required this.siteLocation,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22.0.r),
      ),
      elevation: 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.0.r),
        child: Container(
          color: ColorManager.whiteColor,
          child: ListTile(
            leading: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.share_location_rounded,
                color: ColorManager.primaryColor,
              ),
            ),
            title: Text(
              siteName,
              style: Theme.of(context).textTheme.headlineLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              siteLocation,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            trailing: const Icon(
              CupertinoIcons.chevron_right,
              color: ColorManager.blackColor,
            ),
            onTap: onClicked,
          ),
        ),
      ),
    );
  }
}

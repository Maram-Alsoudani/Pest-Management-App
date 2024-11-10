import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';

import '../../../reports/domain/entities/site_entity.dart';

class SiteInfoItem extends StatelessWidget {
  SiteEntity site;
  SiteInfoItem({required this.site});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          color: ColorManager.greyShade1,
        ),
        child: ListTile(
          leading: Icon(Icons.location_on),
          title: Text(
            site.siteName.toString(),
            style: TextStyle(color: ColorManager.primaryColor),
          ),
          subtitle: Text(
            '${StringManager.siteLocation} ${site.siteLocation.toString()}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            Navigator.pushNamed(context, RoutesManger.routeNamePreviewReport);
          },
        ));
  }
}

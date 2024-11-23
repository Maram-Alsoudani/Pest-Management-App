import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';

import '../../../reports/domain/entities/site_entity.dart';

class SiteInfoItem extends StatelessWidget {
  SiteEntity site;
  final Function()? onDelete;

  SiteInfoItem({required this.site, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Slidable(
              dragStartBehavior: DragStartBehavior.down,
              endActionPane: ActionPane(
                dragDismissible: false,
                motion: const BehindMotion(),
                extentRatio: .25,
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      onDelete!();
                    },
                    backgroundColor: ColorManager.primaryColor,
                    foregroundColor: ColorManager.whiteColor,
                    icon: Icons.delete,
                    label: StringManager.delete,
                  )
                ],
              ),
              child: Container(
                decoration: BoxDecoration(color: ColorManager.greyShade1),
                child: ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(
                    site.siteName.toString(),
                    style: const TextStyle(color: ColorManager.primaryColor),
                  ),
                  subtitle: Text(
                    '${StringManager.siteLocation} ${site.siteLocation.toString()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutesManger.routeNameSiteReportScreen,
                      arguments: {
                        'siteName': site.siteName,
                        'siteId': site.siteId
                      },
                    );
                  },
                ),
              ),
            )));
  }
}
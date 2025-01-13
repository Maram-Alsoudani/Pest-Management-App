import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:bug_away/Config/routes/routes_manger.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';

import '../../../register/data/models/user_model_dto.dart';
import '../../../reports/domain/entities/site_entity.dart';
import '../manager/site_view_model.dart';

class SiteInfoItem extends StatelessWidget {
  final SiteEntity site;
  final Function()? onDelete;
  final bool isAdmin;

  const SiteInfoItem({
    super.key,
    required this.site,
    required this.onDelete,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Slidable(
          dragStartBehavior: DragStartBehavior.down,
          endActionPane: isAdmin
              ? ActionPane(
                  dragDismissible: false,
                  motion: const BehindMotion(),
                  extentRatio: .20,
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        onDelete!();
                      },
                      backgroundColor: ColorManager.primaryColor,
                      foregroundColor: ColorManager.whiteColor,
                      icon: Icons.delete,
                    ),
                  ],
                )
              : null,
          child: Container(
            decoration: const BoxDecoration(color: ColorManager.whiteColor),
            child: ListTile(
              leading: const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Icon(
                  Icons.share_location_sharp,
                  color: ColorManager.primaryColor,
                ),
              ),
              title: Text(
                site.siteName.toString(),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              subtitle: Text(
                '${StringManager.siteLocation} ${site.siteLocation.toString()}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              onTap: () {
                SiteViewModel.get(context).user.type ==
                        UserAndAdminModelDto.user
                    ? Navigator.pushNamed(
                        context,
                        RoutesManger.routeNameSiteReportScreen,
                        arguments: {
                          'siteName': site.siteName,
                          'siteId': site.siteId
                        },
                      )
                    : Navigator.pushNamed(
                        context, RoutesManger.routeNameReportOfSiteScreen,
                        arguments: site.siteId);
              },
            ),
          ),
        ),
      ),
    );
  }
}

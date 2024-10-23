import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Config/theme/theming.dart';
import 'package:pesticides/Features/sites/presentation/pages/sites_detailes/sites_detailes.dart';
import 'package:pesticides/Features/sites/presentation/widgets/list_tile_custom.dart';
import 'package:pesticides/Core/utils/colors.dart';

import '../widgets/expansion_tile_custom.dart';
import '../../../../Core/utils/strings.dart';

class SitesScreen extends StatelessWidget {
  const SitesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringManager.sites,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontSize: 25.sp)),
          actions: [
            Padding(
              padding:  EdgeInsets.all(15.r),
              child: Icon(Icons.maps_home_work_rounded,color: ColorManager.primaryColor,),
            )
          ],
        ),
        body: Container(
          width: 500.w,
          margin: EdgeInsets.all(15.r),
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
              color: ColorManager.whiteColor,
              borderRadius: BorderRadius.circular(15.r)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpansionTileCustom(
                title: "Carrefour",
                children: [
                  ListTileCustom(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text('Maadi',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: ColorManager.primaryColor)),
                        Icon(
                          Icons.location_on,
                          color: ColorManager.primaryColor,
                        )
                      ],
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, RoutesManger.routeNameSitesDetailes);
                    },
                  )
                ],
              ),
              ExpansionTileCustom(
                title: "Carrefour",
                children: [
                  ListTileCustom(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text('Maadi',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: ColorManager.primaryColor)),
                        Icon(
                          Icons.location_on,
                          color: ColorManager.primaryColor,
                        )
                      ],
                    ),
                    onTap: () {},
                  )
                ],
              ),
              ExpansionTileCustom(
                title: "Carrefour",
                children: [
                  ListTileCustom(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text('Maadi',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: ColorManager.primaryColor)),
                        Icon(
                          Icons.location_on,
                          color: ColorManager.primaryColor,
                        )
                      ],
                    ),
                    onTap: () {},
                  )
                ],
              ),
              ExpansionTileCustom(
                title: "Carrefour",
                children: [
                  ListTileCustom(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        Text('Maadi',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: ColorManager.primaryColor)),
                        Icon(
                          Icons.location_on,
                          color: ColorManager.primaryColor,
                        )
                      ],
                    ),
                    onTap: () {},
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

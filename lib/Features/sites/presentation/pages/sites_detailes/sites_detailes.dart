import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Features/sites/presentation/widgets/list_tile_custom.dart';

import '../../../../../Config/routes/routes_manger.dart';
import '../../../../../Core/utils/images.dart';
import '../../widgets/expansion_tile_custom.dart';
import '../../../../../Core/utils/colors.dart';

class SitesDetailes extends StatelessWidget {
  const SitesDetailes({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Carrefour",
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontSize: 25.sp)),
          actions: [
            Padding(
              padding: EdgeInsets.all(15.r),
              child: Icon(
                Icons.location_on,
                color: ColorManager.primaryColor,
              ),
            )
          ],
        ),
        body: Container(
          width: 500.w,
          margin: EdgeInsets.all(15.r),
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
              color: ColorManager.whiteColor,
              borderRadius: BorderRadius.circular(15.r),

            image: DecorationImage(
            opacity: 0.5,
            image: AssetImage(ImageManager.location,
          )
        )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExpansionTileCustom(
                title: "Maddi",
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
                      Navigator.pushReplacementNamed(
                          context, RoutesManger.routeNameSiteReportScreen);
                    },
                  )
                ],
              ),
              ExpansionTileCustom(
                title: "Maddi",
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
                title: "Maddi",
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
                title: "Maddi",
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

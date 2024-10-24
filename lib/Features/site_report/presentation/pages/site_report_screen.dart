import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/component/site_report_item_container.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';

class SiteReportScreen extends StatelessWidget {
  SiteReportScreen({super.key});

  //TODO: Add other screens route names
  List<Map<String, dynamic>> sections = [
    {"title": StringManager.notes, "screen": RoutesManger.routeNameNotesScreen},
    {"title": StringManager.recommendations, "screen": ""},
    {
      "title": StringManager.conditions,
      "screen": RoutesManger.routeNameNotesScreen
    },
    {
      "title": StringManager.materialUsages,
      "screen": RoutesManger.routeNameMaterialUsageScreen
    },
    {"title": StringManager.photos, "screen": ""},
    {"title": StringManager.devices, "screen": ""},
    {"title": StringManager.signatures, "screen": ""},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrefour",
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontSize: 25.sp)),
        actions: [
          Icon(
            Icons.location_on,
            color: ColorManager.primaryColor,
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Text("Maadi"),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          return SiteReportItemContainer(
            title: sections[index]["title"]!,
            onClicked: () {
              Navigator.pushNamed(context, sections[index]["screen"]);
            },
          );
        },
      ),
    );
  }
}

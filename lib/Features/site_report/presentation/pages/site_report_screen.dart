import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/component/site_report_item_container.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';

class SiteReportScreen extends StatefulWidget {
  const SiteReportScreen({Key? key}) : super(key: key);

  @override
  State<SiteReportScreen> createState() => _SiteReportScreenState();
}

class _SiteReportScreenState extends State<SiteReportScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> sections = [
    {"title": StringManager.notes, "screen": RoutesManger.routeNameNotesScreen},
    {"title": StringManager.recommendations, "screen": ""},
    {
      "title": StringManager.conditions,
      "screen": RoutesManger.routeNameConditionsScreen
    },
    {"title": StringManager.material_usages, "screen": ""},
    {"title": StringManager.photos, "screen": ""},
    {"title": StringManager.devices, "screen": ""},
    {"title": StringManager.signatures, "screen": ""},
  ];

  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _slideAnimations = List.generate(sections.length, (index) {
      return Tween<Offset>(
        begin: Offset(-1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.1, // Delay each animation by 100ms
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    Future.delayed(Duration(milliseconds: 300), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
          return SlideTransition(
            position: _slideAnimations[index],
            child: SiteReportItemContainer(
              title: sections[index]["title"]!,
              onClicked: () {
                Navigator.pushNamed(context, sections[index]["screen"]);
              },
            ),
          );
        },
      ),
    );
  }
}

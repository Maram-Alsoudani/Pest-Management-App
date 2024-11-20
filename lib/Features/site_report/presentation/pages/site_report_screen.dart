import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/component/site_report_item_container.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Core/utils/SharedPrefsLocal.dart';
import 'package:pesticides/Features/site_report/data/models/report_dto.dart';
import 'package:pesticides/Features/site_report/presentation/manager/report_view_model.dart';
import 'package:pesticides/Core/utils/firebase_utils.dart';

import '../../domain/entities/report_entity.dart';

class SiteReportScreen extends StatefulWidget {
  const SiteReportScreen({Key? key}) : super(key: key);

  @override
  State<SiteReportScreen> createState() => _SiteReportScreenState();
}

class _SiteReportScreenState extends State<SiteReportScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> sections = [
    {"title": StringManager.notes, "screen": RoutesManger.routeNameNotesScreen},
    {
      "title": StringManager.recommendations,
      "screen": RoutesManger.routeNameRecommendations
    },
    {
      "title": StringManager.conditions,
      "screen": RoutesManger.routeNameConditionsScreen
    },
    {
      "title": StringManager.materialUsages,
      "screen": RoutesManger.routeNameMaterialUsageScreen
    },
    {
      "title": StringManager.photos,
      "screen": RoutesManger.routeNameAddPhotosScreen
    },
    {"title": StringManager.devices, "screen": RoutesManger.routeNameDevice},
    {
      "title": StringManager.signatures,
      "screen": RoutesManger.routeNameSignature
    },
  ];

  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;

  Map<String, dynamic> reportData = {};
  String? siteName;
  String? userId;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _slideAnimations = List.generate(sections.length, (index) {
      return Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      _animationController.forward();
    });

    // Get the current user ID
    userId = SharedPrefsLocal.getData(key: StringManager.keyUserAdmin)?.id;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      siteName = args['siteName'];
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void navigateToSection(String screen, String key) async {
    final result = await Navigator.pushNamed(
      context,
      screen,
      arguments: {key: reportData[key]},
    );
    if (result != null) {
      setState(() {
        reportData[key] = result;
      });
    }
  }

  void submitReport() async {
    final reportViewModel = context.read<ReportViewModel>();
    if (reportViewModel.signatures.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(StringManager.signaturesRequired)),
      );
      return;
    }

    if (userId == null || userId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID is missing.')),
      );
      return;
    }

    final report = ReportEntity(
      id: '',
      siteName: siteName ?? '',
      notes:
          reportViewModel.notes.isNotEmpty ? reportViewModel.notes : 'No notes',
      conditions: reportViewModel.conditions.isNotEmpty
          ? reportViewModel.conditions
          : 'No conditions',
      recommendations: reportViewModel.recommendations.isNotEmpty
          ? reportViewModel.recommendations
          : ['No recommendations'],
      materialUsages: reportViewModel.materials.isNotEmpty
          ? reportViewModel.materials
          : {'No material usages': 0},
      photos: reportViewModel.photos.isNotEmpty
          ? reportViewModel.photos
          : ['No photos'],
      devices: reportViewModel.devices.isNotEmpty
          ? reportViewModel.devices
          : ['No devices'],
      signatures: reportViewModel.signatures,
      userId: userId!,
      createdAt: DateTime.now(),
    );

    await reportViewModel.createReport(report, context);

    // Clear the form after successful submission
    reportViewModel.clearForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: CupertinoColors.transparent,
        title: Text(siteName ?? StringManager.siteReports),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(CupertinoIcons.eye_fill),
              color: ColorManager.whiteColor,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RoutesManger.routeNamePreviewReport,
                  arguments: {'siteName': siteName, 'userId': userId},
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: sections.length,
              itemBuilder: (context, index) {
                return SlideTransition(
                  position: _slideAnimations[index],
                  child: SiteReportItemContainer(
                    title: sections[index]['title'],
                    onClicked: () => navigateToSection(
                        sections[index]['screen'], sections[index]['title']),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 36.0),
            child: Center(
              child: ElevatedButton(
                onPressed: submitReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                  foregroundColor: ColorManager.whiteColor,
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      StringManager.submit,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(width: 8),
                    Icon(CupertinoIcons.paperplane_fill),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

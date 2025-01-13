import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bug_away/Config/routes/routes_manger.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Core/utils/SharedPrefsLocal.dart';
import 'package:bug_away/Features/site_report/presentation/manager/report_view_model.dart';
import 'package:bug_away/Core/component/custom_dialog.dart';
import 'package:bug_away/Core/component/button_custom.dart';

import '../../domain/entities/report_entity.dart';
import '../manager/report_state.dart';
import '../widgets/lottie_send_loading.dart';
import '../widgets/site_report_item.dart';

class SiteReportScreen extends StatefulWidget {
  const SiteReportScreen({super.key});

  @override
  State<SiteReportScreen> createState() => _SiteReportScreenState();
}

class _SiteReportScreenState extends State<SiteReportScreen>
    with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> sections = [
    {
      "title": StringManager.notes,
      "screen": RoutesManger.routeNameNotesScreen,
      "icon": CupertinoIcons.pencil_circle_fill
    },
    {
      "title": StringManager.recommendations,
      "screen": RoutesManger.routeNameRecommendations,
      "icon": CupertinoIcons.checkmark_seal_fill
    },
    {
      "title": StringManager.conditions,
      "screen": RoutesManger.routeNameConditionsScreen,
      "icon": CupertinoIcons.info_circle_fill
    },
    {
      "title": StringManager.materialUsages,
      "screen": RoutesManger.routeNameMaterialUsageScreen,
      "icon": CupertinoIcons.cube_box_fill
    },
    {
      "title": StringManager.photos,
      "screen": RoutesManger.routeNameAddPhotosScreen,
      "icon": CupertinoIcons.photo_fill
    },
    {
      "title": StringManager.devices,
      "screen": RoutesManger.routeNameDevice,
      "icon": CupertinoIcons.today_fill
    },
    {
      "title": StringManager.signatures,
      "screen": RoutesManger.routeNameSignature,
      "icon": CupertinoIcons.signature
    },
  ];

  late AnimationController _animationController;
  late List<Animation<Offset>> _slideAnimations;

  Map<String, dynamic> reportData = {};
  String? siteName;
  String? siteId;
  String? userId;
  String? userName;

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
    userId = SharedPrefsLocal.getData(key: StringManager.userAdmin)?.id;
    // Get the current user name
    userName = SharedPrefsLocal.getData(key: StringManager.userAdmin)?.userName;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      siteName = args['siteName'];
      siteId = args['siteId'];
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
      DialogUtils.showAlertDialog(
        context: context,
        title: 'Error',
        message: StringManager.signaturesRequired,
        posActionTitle: 'OK',
      );
      return;
    }

    if (userId == null || userId!.isEmpty) {
      DialogUtils.showAlertDialog(
        context: context,
        title: StringManager.error,
        message: StringManager.userIdMissing,
        posActionTitle: StringManager.ok,
      );
      return;
    }

    final report = ReportEntity(
      id: '',
      siteId: siteId ?? '',
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
      createdBy: userName!,
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
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
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
      body: BlocConsumer<ReportViewModel, ReportState>(
        listener: (context, state) {
          if (state is ReportCreated) {
            DialogUtils.showAlertDialog(
              context: context,
              title: StringManager.success,
              message: StringManager.reportSubmitSuccess,
              posActionTitle: StringManager.ok,
              posAction: () {
                Navigator.pushNamed(
                    context, RoutesManger.routeNameCategoryScreen);
              },
            );
          } else if (state is ReportError) {
            DialogUtils.showAlertDialog(
              context: context,
              title: StringManager.error,
              message: state.message,
              posActionTitle: StringManager.ok,
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Column(
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
                                sections[index]['screen'],
                                sections[index]['title']),
                            icon: sections[index]['icon'],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 36.0),
                    child: Center(
                      child: ButtonCustom(
                        buttonName: StringManager.submit,
                        onTap: submitReport,
                        textStyle: Theme.of(context).textTheme.titleSmall,
                        icon: CupertinoIcons.paperplane_fill,
                      ),
                    ),
                  ),
                ],
              ),
              if (state is ReportLoading)
                Container(
                  color: ColorManager.overlayColor,
                  child: const Center(
                    child: LottieSendingWidget(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

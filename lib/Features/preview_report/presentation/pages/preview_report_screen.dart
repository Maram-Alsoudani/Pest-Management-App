import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bug_away/Features/site_report/presentation/manager/report_view_model.dart';
import 'package:bug_away/Features/preview_report/presentation/widgets/device_widget.dart';
import 'package:bug_away/Features/preview_report/presentation/widgets/recommendtions_and_materiel_usages_widget.dart';
import '../../../site_report/domain/entities/report_entity.dart';
import '../../../site_report/presentation/manager/report_state.dart';
import '../../../site_report/presentation/widgets/lottie_send_loading.dart';
import '../widgets/image_viewer_widget.dart';
import '../widgets/title_divider_widget.dart';
import '../../../../Core/component/custom_dialog.dart';
import '../../../../Core/utils/SharedPrefsLocal.dart';
import '../../../register/data/models/user_model_dto.dart';

class PreviewReportScreen extends StatefulWidget {
  const PreviewReportScreen({super.key});

  @override
  State<PreviewReportScreen> createState() => _PreviewReportScreenState();
}

class _PreviewReportScreenState extends State<PreviewReportScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _slideAnimation =
        Tween<Offset>(begin: Offset(-1.w, 0), end: const Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Trigger the slide animation after the page loads
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });

        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _viewImage(Uint8List image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageViewerDialog(imageBytes: image);
      },
    );
  }

  void _viewFileImage(File image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageViewerDialog(imageFile: image);
      },
    );
  }

  void _submitReport() async {
    final reportViewModel = context.read<ReportViewModel>();
    if (reportViewModel.signatures.isEmpty) {
      DialogUtils.showAlertDialog(
        context: context,
        title: StringManager.error,
        message: StringManager.signaturesRequired,
        posActionTitle: StringManager.ok,
      );
      return;
    }

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final siteName = args?['siteName'] ?? StringManager.siteName;
    final userId = args?['userId'] ?? StringManager.userIdRequired;
    final siteId = args?['siteId'] ?? StringManager.siteName;
    if (userId == null || userId.isEmpty) {
      DialogUtils.showAlertDialog(
        context: context,
        title: StringManager.error,
        message: StringManager.userIdRequired,
        posActionTitle: StringManager.ok,
      );
      return;
    }

    // Get the current user's information
    UserAndAdminModelDto? currentUser =
        SharedPrefsLocal.getData(key: 'currentUser');
    String createdBy = currentUser?.userName ?? 'Unknown User';

    final report = ReportEntity(
      id: '',
      siteId: siteId,
      siteName: siteName,
      notes: reportViewModel.notes.isNotEmpty
          ? reportViewModel.notes
          : StringManager.noNotes,
      conditions: reportViewModel.conditions.isNotEmpty
          ? reportViewModel.conditions
          : StringManager.noConditions,
      recommendations: reportViewModel.recommendations.isNotEmpty
          ? reportViewModel.recommendations
          : [StringManager.noRecommendations],
      materialUsages: reportViewModel.materials.isNotEmpty
          ? reportViewModel.materials
          : {StringManager.noMaterialUsages: 0},
      photos: reportViewModel.photos.isNotEmpty
          ? reportViewModel.photos
          : [StringManager.noPhotos],
      devices: reportViewModel.devices.isNotEmpty
          ? reportViewModel.devices
          : [StringManager.noDevices],
      signatures: reportViewModel.signatures,
      userId: userId,
      createdBy: createdBy,
      createdAt: DateTime.now(),
    );

    await reportViewModel.createReport(report, context);
  }

  @override
  Widget build(BuildContext context) {
    final reportViewModel = context.read<ReportViewModel>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringManager.previewReport,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontSize: 25.sp)),
          actions: [
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: () async {
                final args = ModalRoute.of(context)?.settings.arguments
                    as Map<String, dynamic>?;
                final siteName = args?['siteName'] ?? StringManager.siteName;
                final userId = args?['userId'] ?? StringManager.userIdRequired;
                final siteId = args?['siteId'] ?? StringManager.siteName;

                // Get the current user's information
                var createdBy =
                    SharedPrefsLocal.getData(key: StringManager.userAdmin)
                        ?.userName;

                final report = ReportEntity(
                  id: '',
                  siteId: siteId,
                  siteName: siteName,
                  notes: reportViewModel.notes.isNotEmpty
                      ? reportViewModel.notes
                      : StringManager.noNotes,
                  conditions: reportViewModel.conditions.isNotEmpty
                      ? reportViewModel.conditions
                      : StringManager.noConditions,
                  recommendations: reportViewModel.recommendations.isNotEmpty
                      ? reportViewModel.recommendations
                      : [StringManager.noRecommendations],
                  materialUsages: reportViewModel.materials.isNotEmpty
                      ? reportViewModel.materials
                      : {StringManager.noMaterialUsages: 0},
                  photos: reportViewModel.photos.isNotEmpty
                      ? reportViewModel.photos
                      : [StringManager.noPhotos],
                  devices: reportViewModel.devices.isNotEmpty
                      ? reportViewModel.devices
                      : [StringManager.noDevices],
                  signatures: reportViewModel.signatures,
                  userId: userId,
                  createdBy: createdBy ?? 'Unknown User',
                  createdAt: DateTime.now(),
                );

                await reportViewModel.generateAndDownloadPdf(report);
              },
            ),
          ],
        ),
        body: BlocConsumer<ReportViewModel, ReportState>(
          listener: (context, state) {
            if (state is ReportError) {
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
                Container(
                  width: 500.w,
                  margin: EdgeInsets.all(15.r),
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: ColorManager.whiteColor,
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display Notes
                        const SectionTitleWithDivider(
                            title: StringManager.notes),
                        SizedBox(height: 8.h),
                        Text(
                          reportViewModel.notes.isNotEmpty
                              ? reportViewModel.notes
                              : StringManager.noNotes,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: ColorManager.blackColor),
                        ),
                        SizedBox(height: 16.h),

                        // Display Conditions
                        const SectionTitleWithDivider(
                            title: StringManager.conditions),
                        SizedBox(height: 8.h),
                        Text(
                          reportViewModel.conditions.isNotEmpty
                              ? reportViewModel.conditions
                              : StringManager.noConditions,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: ColorManager.blackColor),
                        ),
                        SizedBox(height: 16.h),

                        // Display Recommendations
                        MaterialUsagesAndRecommendtions(
                          title: StringManager.recommendations,
                          materials: reportViewModel.recommendations.isNotEmpty
                              ? {
                                  for (var item
                                      in reportViewModel.recommendations)
                                    item: 1
                                }
                              : {StringManager.noRecommendations: 0},
                          opacity: _opacity,
                          position: _slideAnimation,
                        ),
                        SizedBox(height: 16.h),

                        // Display Material Usages
                        MaterialUsagesAndRecommendtions(
                          title: StringManager.materialUsages,
                          materials: reportViewModel.materials.isNotEmpty
                              ? reportViewModel.materials
                              : {StringManager.noMaterialUsages: 0},
                          opacity: _opacity,
                          position: _slideAnimation,
                        ),
                        SizedBox(height: 16.h),

                        // Display Photos
                        const SectionTitleWithDivider(
                            title: StringManager.photos),
                        SizedBox(height: 8.h),
                        SizedBox(
                          height: 80.h,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: reportViewModel.photos.isNotEmpty
                                ? ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: reportViewModel.photos.length,
                                    itemBuilder: (context, index) {
                                      final photoPath =
                                          reportViewModel.photos[index];
                                      final file = File(photoPath);
                                      return GestureDetector(
                                        onTap: () => _viewFileImage(file),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0.w),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            child: Container(
                                              width: 80.w,
                                              height: 80.h,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                              ),
                                              child: Image.file(
                                                file,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      StringManager.noPhotos,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: ColorManager.blackColor),
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Display Devices
                        DeviceWidget(
                          opacity: _opacity,
                          position: _slideAnimation,
                        ),
                        SizedBox(height: 16.h),

                        // Display Signatures
                        const SectionTitleWithDivider(
                            title: StringManager.signatures),
                        SizedBox(height: 8.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: reportViewModel.signatures.map((signature) {
                            final file = File(signature);
                            return GestureDetector(
                              onTap: () => _viewFileImage(file),
                              child: Container(
                                width: 80.w,
                                height: 80.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: ColorManager.primaryColor),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.file(
                                    file,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (reportViewModel.signatures.isEmpty)
                          Text(StringManager.signaturesRequired,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: ColorManager.redColor)),
                      ],
                    ),
                  ),
                ),
                if (state is ReportLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: LottieSendingWidget(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

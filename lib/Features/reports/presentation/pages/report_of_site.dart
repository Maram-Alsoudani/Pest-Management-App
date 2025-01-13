import 'package:bug_away/Core/component/empty_pages.dart';
import 'package:bug_away/Core/component/loading_items_widget.dart';
import 'package:bug_away/Core/utils/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bug_away/Features/reports/presentation/manager/get_report_of_site_states.dart';
import 'package:bug_away/Features/reports/presentation/manager/report_of_site_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../Core/component/lottie_loading_widget.dart';
import '../../../../Core/utils/colors.dart';
import '../../../../Core/utils/strings.dart';
import '../../../../di/di.dart';
import '../../../preview_report/presentation/widgets/device_widget.dart';
import '../../../preview_report/presentation/widgets/image_viewer_widget.dart';
import '../../../preview_report/presentation/widgets/recommendtions_and_materiel_usages_widget.dart';
import '../../../preview_report/presentation/widgets/title_divider_widget.dart';

class ReportOfSite extends StatefulWidget {
  const ReportOfSite({super.key});

  @override
  State<ReportOfSite> createState() => _ReportOfSiteState();
}

class _ReportOfSiteState extends State<ReportOfSite>
    with SingleTickerProviderStateMixin {
  void _viewImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageViewerDialog(imageUrl: imageUrl);
      },
    );
  }

  @override
  void dispose() {
    viewModel.animationController.dispose();
    super.dispose();
  }

  ReportOfSiteViewModel viewModel = getIt<ReportOfSiteViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.initializeAnimation(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var args = ModalRoute.of(context)!.settings.arguments as String;
      viewModel.getReportOfSite(args);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          StringManager.reports.substring(0, StringManager.reports.length - 1),
          style:
              Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 25.sp),
        ),
        actions: [
          if (viewModel.state is GetReportOfSiteSuccessState)
            IconButton(
              icon: const Icon(CupertinoIcons.cloud_download),
              onPressed: () async {
                final report =
                    (viewModel.state as GetReportOfSiteSuccessState).siteReport;
                await viewModel.generateAndDownloadPdf(report);
              },
            ),
        ],
      ),
      body: BlocBuilder<ReportOfSiteViewModel, GetReportOfSiteState>(
        bloc: viewModel,
        builder: (context, state) {
          return ModalProgressHUD(
            opacity: 0.4,
            color: ColorManager.greyShade3,
            inAsyncCall: viewModel.isLoading,
            progressIndicator: const Center(child: LottieLoadingWidget()),
            child: state is GetReportOfSiteSuccessState
                ? SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(15.r),
                      child: Container(
                        color: ColorManager.whiteColor,
                        padding: EdgeInsets.all(12.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Display Notes
                            const SectionTitleWithDivider(
                                title: StringManager.notes),
                            SizedBox(height: 8.h),
                            Text(
                              state.siteReport.notes.isNotEmpty
                                  ? state.siteReport.notes
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
                              state.siteReport.conditions.isNotEmpty
                                  ? state.siteReport.conditions
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
                              materials: state
                                      .siteReport.recommendations.isNotEmpty
                                  ? {
                                      for (var item
                                          in state.siteReport.recommendations)
                                        item: 1
                                    }
                                  : {StringManager.noRecommendations: 0},
                              opacity: viewModel.opacity,
                              position: viewModel.slideAnimation,
                            ),
                            SizedBox(height: 16.h),

                            // Display Material Usages
                            MaterialUsagesAndRecommendtions(
                              title: StringManager.materialUsages,
                              materials:
                                  state.siteReport.materialUsages.isNotEmpty
                                      ? state.siteReport.materialUsages
                                      : {StringManager.noMaterialUsages: 0},
                              opacity: viewModel.opacity,
                              position: viewModel.slideAnimation,
                            ),
                            SizedBox(height: 16.h),

                            // Display Photos
                            const SectionTitleWithDivider(
                                title: StringManager.photos),
                            SizedBox(height: 8.h),
                            SizedBox(
                              height: 80.h,
                              child: SlideTransition(
                                position: viewModel.slideAnimation,
                                child: state.siteReport.photos.isNotEmpty
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            state.siteReport.photos.length,
                                        itemBuilder: (context, index) {
                                          final photoPath =
                                              state.siteReport.photos[index];
                                          return GestureDetector(
                                            onTap: () => _viewImage(photoPath),
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
                                                        BorderRadius.circular(
                                                            8.r),
                                                  ),
                                                  child: CachedNetworkImage(
                                                    imageUrl: photoPath,
                                                    fit: BoxFit.cover,
                                                    placeholder: (context,
                                                            url) =>
                                                        const LottieLoadingWidget(),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
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
                                                  color:
                                                      ColorManager.blackColor),
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Display Devices
                            DeviceWidget(
                              opacity: viewModel.opacity,
                              position: viewModel.slideAnimation,
                            ),
                            SizedBox(height: 16.h),

                            // Display Signatures
                            const SectionTitleWithDivider(
                                title: StringManager.signatures),
                            SizedBox(height: 8.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children:
                                  state.siteReport.signatures.map((signature) {
                                return GestureDetector(
                                  onTap: () => _viewImage(signature),
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
                                      child: CachedNetworkImage(
                                        imageUrl: signature,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const LottieLoadingWidget(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            if (state.siteReport.signatures.isEmpty)
                              Text(StringManager.signaturesRequired,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: ColorManager.redColor)),
                          ],
                        ),
                      ),
                    ),
                  )
                : const EmptyStateWidget(
                    lottiePath: ImageManager.emptyReportLottie,
                    message: StringManager.noReportFound,
                  ),
          );
        },
      ),
    );
  }
}

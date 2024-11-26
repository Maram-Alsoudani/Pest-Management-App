import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pesticides/Features/reports/presentation/manager/get_report_of_site_states.dart';
import 'package:pesticides/Features/reports/presentation/manager/report_of_site_view_model.dart';

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
  void _viewImage(Uint8List image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageViewerDialog(imageBytes: image);
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    viewModel.animationController.dispose();
    super.dispose();
  }

  void _viewFileImage(File image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageViewerDialog(imageFile: image);
      },
    );
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            StringManager.reports
                .substring(0, StringManager.reports.length - 1),
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontSize: 25.sp),
          ),
        ),
        body: BlocBuilder<ReportOfSiteViewModel, GetReportOfSiteState>(
          bloc: viewModel,
          builder: (context, state) {
            return ModalProgressHUD(
              opacity: 0.4,
              color: ColorManager.greyShade3,
              inAsyncCall: viewModel.isLoading,
              progressIndicator: const Center(child: LottieLoadingWidget()),
              child: state is GetReportOfSiteErrorState
                  ? Center(
                      child: Text(
                        state.errorMessage,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.white),
                      ),
                    )
                  : state is GetReportOfSiteSuccessState
                      ? Container(
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
                                // Animated Notes Section
                                const SectionTitleWithDivider(
                                    title: StringManager.notes),
                                SizedBox(height: 8.h),
                                SlideTransition(
                                  position: viewModel.slideAnimation,
                                  child: Opacity(
                                    opacity: viewModel.opacity,
                                    child: Text(
                                      state.siteReport.notes,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: ColorManager.blackColor),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),

                                // Animated Conditions Section
                                const SectionTitleWithDivider(
                                    title: StringManager.conditions),
                                SizedBox(height: 8.h),
                                SlideTransition(
                                  position: viewModel.slideAnimation,
                                  child: Opacity(
                                    opacity: viewModel.opacity,
                                    child: Text(
                                      state.siteReport.conditions,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: ColorManager.blackColor),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),

                                // Display Recommendations
                                MaterialUsagesAndRecommendtions(
                                  title: StringManager.recommendations,
                                  materials: state
                                          .siteReport.recommendations.isNotEmpty
                                      ? {
                                          for (var item in state
                                              .siteReport.recommendations)
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
                                // SizedBox(
                                //   height: 80.h,
                                //   // Set the height for the horizontal ListView
                                //   child: SlideTransition(
                                //     position: viewModel.slideAnimation,
                                //     child: state.siteReport.photos.isNotEmpty
                                //         ? ListView.builder(
                                //             scrollDirection: Axis.horizontal,
                                //             itemCount:
                                //                 state.siteReport.photos.length,
                                //             itemBuilder: (context, index) {
                                //               final photoPath = state
                                //                   .siteReport.photos[index];
                                //               if (File(photoPath)
                                //                   .existsSync()) {
                                //                 return GestureDetector(
                                //                   onTap: () => _viewFileImage(
                                //                       File(photoPath)),
                                //                   child: Padding(
                                //                     padding:
                                //                         EdgeInsets.symmetric(
                                //                             horizontal: 8.0.w),
                                //                     child: ClipRRect(
                                //                       borderRadius:
                                //                           BorderRadius.circular(
                                //                               8.r),
                                //                       child: Container(
                                //                         width: 80.w,
                                //                         height: 80.h,
                                //                         decoration:
                                //                             BoxDecoration(
                                //                           borderRadius:
                                //                               BorderRadius
                                //                                   .circular(
                                //                                       8.r),
                                //                         ),
                                //                         child: Image.file(
                                //                           File(photoPath),
                                //                           fit: BoxFit.cover,
                                //                         ),
                                //                       ),
                                //                     ),
                                //                   ),
                                //                 );
                                //               } else {
                                //                 return Center(
                                //                   child: Text(
                                //                     'Invalid photo path: $photoPath',
                                //                     style: Theme.of(context)
                                //                         .textTheme
                                //                         .bodyMedium!
                                //                         .copyWith(
                                //                             color: Colors.red),
                                //                   ),
                                //                 );
                                //               }
                                //             },
                                //           )
                                //         : Center(
                                //             child: Text(
                                //               StringManager.noPhotos,
                                //               style: Theme.of(context)
                                //                   .textTheme
                                //                   .bodyMedium!
                                //                   .copyWith(
                                //                       color: ColorManager
                                //                           .blackColor),
                                //             ),
                                //           ),
                                //   ),
                                // ),
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
                                // Wrap(
                                //   spacing: 8.w,
                                //   runSpacing: 8.h,
                                //   children: state.siteReport.signatures
                                //       .map((signature) {
                                //     return GestureDetector(
                                //       onTap: () => _viewImage(
                                //           Uint8List.fromList(
                                //               signature.codeUnits)),
                                //       child: Container(
                                //         width: 80.w,
                                //         height: 80.h,
                                //         decoration: BoxDecoration(
                                //           border: Border.all(
                                //               color: ColorManager.primaryColor),
                                //           borderRadius:
                                //               BorderRadius.circular(8.r),
                                //         ),
                                //         child: ClipRRect(
                                //           borderRadius:
                                //               BorderRadius.circular(8.r),
                                //           child: Image.memory(
                                //             Uint8List.fromList(
                                //                 signature.codeUnits),
                                //             fit: BoxFit.cover,
                                //           ),
                                //         ),
                                //       ),
                                //     );
                                //   }).toList(),
                                // ),
                                if (state.siteReport.signatures.isEmpty)
                                  Text(
                                    StringManager.signaturesRequired,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.red),
                                  ),
                                SizedBox(height: 16.h),
                              ],
                            ),
                          ),
                        )
                      : Container(),
            );
          },
        ),
      ),
    );
  }
}

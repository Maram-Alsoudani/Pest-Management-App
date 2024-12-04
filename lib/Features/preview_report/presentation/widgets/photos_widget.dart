import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/site_report/presentation/manager/report_view_model.dart';

import 'image_viewer_widget.dart';

class PhotosWidget extends StatelessWidget {
  final double opacity;
  final Animation<Offset> position;
  const PhotosWidget(
      {super.key, required this.opacity, required this.position});

  void _viewImage(BuildContext context, File image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ImageViewerDialog(imageFile: image);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final reportViewModel = context.read<ReportViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedOpacity(
          duration: const Duration(seconds: 2),
          opacity: opacity,
          curve: Curves.easeIn,
          child: Text(StringManager.photos,
              style: Theme.of(context).textTheme.bodyLarge),
        ),
        SizedBox(
          height: 80.h,
          child: SlideTransition(
            position: position,
            child: reportViewModel.photos.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: reportViewModel.photos.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _viewImage(
                            context, File(reportViewModel.photos[index])),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: Container(
                              width: 80.w,
                              height: 80.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Image.file(
                                File(reportViewModel.photos[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(StringManager.noPhotos,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
          ),
        ),
      ],
    );
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/component/lottie_loading_widget.dart';

class ImageViewerDialog extends StatelessWidget {
  final Uint8List? imageBytes;
  final File? imageFile;
  final String? imageUrl;

  const ImageViewerDialog(
      {super.key, this.imageBytes, this.imageFile, this.imageUrl})
      : assert(imageBytes != null || imageFile != null || imageUrl != null);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: imageBytes != null
            ? Image.memory(imageBytes!)
            : imageFile != null
                ? Image.file(imageFile!)
                : CachedNetworkImage(
                    imageUrl: imageUrl!,
                    placeholder: (context, url) => const LottieLoadingWidget(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.contain,
                  ),
      ),
    );
  }
}

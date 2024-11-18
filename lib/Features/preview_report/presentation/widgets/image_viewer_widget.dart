import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageViewerDialog extends StatelessWidget {
  final Uint8List? imageBytes;
  final File? imageFile;

  const ImageViewerDialog({super.key, this.imageBytes, this.imageFile})
      : assert(imageBytes != null || imageFile != null);

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
            : Image.file(imageFile!),
      ),
    );
  }
}

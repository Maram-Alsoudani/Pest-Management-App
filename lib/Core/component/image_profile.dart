import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pesticides/Core/utils/colors.dart';
import '../utils/images.dart';

class ImageProfile extends StatelessWidget {
  final double radius;
  final String? imageUrl;

  const ImageProfile({super.key, required this.radius, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: ColorManager.whiteColor,
      radius: radius,
      backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
          ? (imageUrl!.startsWith('http')
              ? NetworkImage(imageUrl!)
              : FileImage(File(imageUrl!))) as ImageProvider
          : const AssetImage(ImageManager.image_profile) as ImageProvider,
    );
  }
}

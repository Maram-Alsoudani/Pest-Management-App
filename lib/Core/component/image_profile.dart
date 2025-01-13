import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bug_away/Core/utils/colors.dart';
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
      backgroundImage: _getImageProvider(),
    );
  }

  ImageProvider _getImageProvider() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      if (imageUrl!.startsWith('http')) {
        return CachedNetworkImageProvider(imageUrl!);
      } else {
        return FileImage(File(imageUrl!));
      }
    } else {
      return const AssetImage(ImageManager.avatar);
    }
  }
}

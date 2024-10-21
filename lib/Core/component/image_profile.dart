
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/colors.dart';

import '../utils/images.dart';

class ImageProfile extends StatelessWidget {
  final double radius;

  const ImageProfile({super.key,required this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor:
      ColorManager.whiteColor,
      radius: radius,
      backgroundImage:
      AssetImage(ImageManager.image_profile),
    );
  }
}

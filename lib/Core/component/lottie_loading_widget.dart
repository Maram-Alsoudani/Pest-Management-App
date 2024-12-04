import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../utils/images.dart';

class LottieLoadingWidget extends StatelessWidget {
  final double width;
  final double height;

  const LottieLoadingWidget({
    super.key,
    this.width = 200,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(ImageManager.loadingLottie,
        width: width.r, height: height.r, fit: BoxFit.cover);
  }
}

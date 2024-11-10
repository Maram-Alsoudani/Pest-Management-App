import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:pesticides/Core/utils/images.dart';

class LottieLoadingWidget extends StatelessWidget {
  final double width;
  final double height;

  const LottieLoadingWidget({
    Key? key,
    this.width = 200,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
        ImageManager.loadingLottie,
      width: width.r,
      height: height.r,
      fit: BoxFit.cover
    );
  }
}

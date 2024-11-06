import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class LottieLoadingWidget extends StatelessWidget {
  final double width;
  final double height;

  const LottieLoadingWidget({
    Key? key,
    this.width = 100,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/loading.json',
      width: width.r,
      height: height.r,
    );
  }
}

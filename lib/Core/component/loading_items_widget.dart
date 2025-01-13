import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../utils/images.dart';

class ItemsLoadingWidget extends StatelessWidget {
  final double width;
  final double height;

  const ItemsLoadingWidget({
    super.key,
    this.width = 150,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(ImageManager.emptyItemsLottie,
        width: width.r, height: height.r, fit: BoxFit.cover);
  }
}

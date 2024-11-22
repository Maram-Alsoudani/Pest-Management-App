import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pesticides/Core/utils/images.dart';

class LottieSendingWidget extends StatelessWidget {
  final double width;
  final double height;

  const LottieSendingWidget({
    Key? key,
    this.width = 200.0,
    this.height = 200.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        ImageManager.sendingLottie,
        width: width * 1.5,
        height: height * 1.2,
        fit: BoxFit.fill,
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/colors.dart';

class LabelText extends StatelessWidget {
  final String label;

  const LabelText({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
        color: ColorManager.blackColor,
        fontSize: 21.sp,
      ),
    );
  }
}
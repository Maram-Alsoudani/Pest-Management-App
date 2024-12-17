import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/colors.dart';

class LabelText extends StatelessWidget {
  final String label;
  double? fontSize;
  Color? color;
  LabelText({super.key, required this.label, this.fontSize, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: color ?? ColorManager.blackColor,
            fontSize: fontSize ?? 20.sp,
          ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/colors.dart';

class LabelText extends StatelessWidget {
  final String label;
  final double? fontSize;
  final Color? color;
  const LabelText({super.key, required this.label, this.fontSize, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: color ?? ColorManager.whiteColor,
            fontSize: fontSize ?? 16.sp,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

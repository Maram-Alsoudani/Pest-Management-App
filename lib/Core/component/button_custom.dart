import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/colors.dart';

class ButtonCustom extends StatelessWidget {
  final String buttonName;
  final Function onTap;
  final TextStyle? textStyle;

  const ButtonCustom({
    super.key,
    required this.buttonName,
    required this.onTap,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
      onPressed: () {
        onTap();
      },
      child: Text(
        buttonName,
        style: textStyle ?? Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}

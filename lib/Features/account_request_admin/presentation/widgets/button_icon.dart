import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/colors.dart';

class ButtonAndIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;
  final Color color;
  const ButtonAndIcon({
    super.key,
    required this.color,
    required this.title,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: () {
          onTap();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Icon(
              icon,
              size: 20.sp,
              color: ColorManager.whiteColor,
            ),
          ],
        ),
      ),
    );
  }
}

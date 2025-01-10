import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:bug_away/Core/utils/colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String lottiePath;
  final String message;

  const EmptyStateWidget({
    super.key,
    required this.lottiePath,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 120.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              lottiePath,
              width: 200.w,
              height: 200.h,
              repeat: false,
            ),
            SizedBox(height: 24.h),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: ColorManager.whiteColor,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

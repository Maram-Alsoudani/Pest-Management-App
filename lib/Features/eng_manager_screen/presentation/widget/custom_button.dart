import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/utils/colors.dart';
import '../../../../Core/utils/font_manager.dart';

class CustomButton extends StatelessWidget {
  final String name;
  final String type;
  final String? backgroundImage;
  final String boxImage;
  final String routeName;

  const CustomButton({
    super.key,
    required this.name,
    this.backgroundImage,
    required this.boxImage,
    required this.routeName,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, routeName, arguments: type);
      },
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: 60.h),
            padding: EdgeInsets.only(top: 60.h),
            height: 165.h,
            width: 170.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36.r),
              color: backgroundImage == null ? ColorManager.primaryColor : null,
              image: backgroundImage != null
                  ? DecorationImage(
                      image: AssetImage(backgroundImage!),
                      opacity: 0.9,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                name,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: FontSize.s24.sp,
                      fontWeight: FontWeightManager.bold,
                      color: ColorManager.blackColor,
                    ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: 150.w,
              height: 140.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: DecorationImage(
                  image: AssetImage(boxImage),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

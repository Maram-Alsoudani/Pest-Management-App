import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/utils/colors.dart';
import '../../../../Core/utils/font_manager.dart';

class CustomButton extends StatelessWidget {
  final String name;
  final String image;
  final String routeName;


  CustomButton({required this.name , required this.image , required this.routeName});

  @override
  Widget build(BuildContext context) {
    // on tap navigate to another screen
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacementNamed(context, routeName);
      },

    // the UI of the Screen
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 70.w),
        padding: EdgeInsets.symmetric(vertical: 40.h,horizontal: 10.w),
        decoration: BoxDecoration(
          border: Border.all(color: ColorManager.whiteColor),
          borderRadius: BorderRadius.circular(80.r)
        ),
        child: Column(
          children: [
            Image.asset(image , width: 100.w  ,height: 100.h,),
            SizedBox(height: 20.h,),
            Text(name,style: Theme.of(context).textTheme.titleSmall!.copyWith(
              fontSize: FontSize.s24.sp,
              fontWeight: FontWeightManager.bold
            ),)
          ],
        ),
      ),
    );
  }
}

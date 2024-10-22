import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/utils/images.dart';
import '../widget/custom_button.dart';

class EngOwnerScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            ImageManager.logoTeam,
            height: 220.h,
            width: 400.w,
            fit: BoxFit.fill,
          ),
          SizedBox(height: 30.h,),
          CustomButton(name: 'Engineer ',image: ImageManager.engIcon,),
          SizedBox(height: 30.h,),
          CustomButton(name: 'Administrator',image: ImageManager.ownerIcon,),
        ],
      ),

    );
  }
}

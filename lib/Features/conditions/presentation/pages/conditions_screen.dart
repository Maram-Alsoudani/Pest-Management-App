import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/strings.dart';

import '../../../../Core/utils/colors.dart';

class ConditionsScreen extends StatefulWidget {
  ConditionsScreen({super.key});

  @override
  State<ConditionsScreen> createState() => _ConditionsScreenState();
}

class _ConditionsScreenState extends State<ConditionsScreen> {
  final int maxCharacters = 500;
  String inputText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrefour",  style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(fontSize: 25.sp)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Icon(
              Icons.check,
              size: 35.sp,
              color: ColorManager.primaryColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              maxLength: maxCharacters,
              onChanged: (text) {
                setState(() {
                  inputText = text;
                });
              },
              cursorColor: ColorManager.primaryColor,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorManager.whiteColor,
                  hintText: StringManager.enter_conditions,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: ColorManager.greyShade4),
                  counterStyle: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: ColorManager.greyShade4)),
              maxLines: 15,
            ),
          ],
        ),
      ),
    );
  }
}

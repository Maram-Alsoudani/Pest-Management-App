import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../Core/utils/colors.dart';

class BuildInfoCard extends StatelessWidget {
  String title;
  String value;

  BuildInfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      child: ListTile(
        leading:
            const Icon(CupertinoIcons.info, color: ColorManager.primaryColor),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}

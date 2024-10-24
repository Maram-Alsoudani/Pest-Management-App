import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Core/utils/colors.dart';
import '../../../../Core/utils/strings.dart';
import '../widgets/custome_date_table.dart';

class DeviceScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.device),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.r),
                    color: ColorManager.whiteColor),
                child: Text(
                  StringManager.deviceNewScan,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: ColorManager.backgroundColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              StringManager.deviceLastScan,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontSize: 25.sp, fontWeight: FontWeight.bold),
            ),
            Divider(
              color: ColorManager.primaryColor,
            ),
            //Data TAble
            CustomeDateTable(),
          ],
        ),
      ),
    );
  }
}

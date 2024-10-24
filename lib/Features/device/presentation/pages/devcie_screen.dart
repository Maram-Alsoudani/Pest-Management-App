import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/component/button_custom.dart';
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
            ButtonCustom(buttonName: StringManager.deviceNewScan, onTap: (){}),

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

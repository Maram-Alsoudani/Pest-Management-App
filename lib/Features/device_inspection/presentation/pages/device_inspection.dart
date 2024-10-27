import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/device_inspection/presentation/widgets/custom_text.dart';
import '../widgets/add_material.dart';
import '../widgets/custom_drop_down_menu.dart';

class DeviceInspection extends StatefulWidget {
  @override
  State<DeviceInspection> createState() => _DeviceInspectionState();
}

class _DeviceInspectionState extends State<DeviceInspection> {
  bool? _check = false;

  List<String> materialsList = [
    'Bleach',
    'Chlorine',
    'Sulfuric Acid',
    'Hydrochloric Acid',
    'Nitric Acid',
    'Funnel Trap',
    'Pyrethroids',
    'Neonicotinoids',
    'Insect Growth Regulators (IGRs)',
    'Boric Acid',
    'Diatomaceous Earth',
    'Glue Traps',
    'Rodent Bait Stations',
    'Insect Light Traps (ILTs)',
    'Pheromone Traps',
    'Termite Bait Systems',
  ];
  List<String> pestList = [
    'rat',
    'fly',
    'cockroach',
  ];
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        StringManager.deviceInspection,
      )),
      body: Padding(
        padding: EdgeInsets.all(15.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  title: '${StringManager.deviceInspectionID} : ${args}',
                ),
                Text(
                  StringManager.deviceInspectionLastScanned,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            Divider(
              color: ColorManager.whiteColor,
            ),
            CustomText(
              title: StringManager.deviceInspectionDeviceCondition,
            ),
            SizedBox(
              height: 10.h,
            ),
            CustomDropDownMenu(),
            Divider(
              color: ColorManager.whiteColor,
            ),
            CustomText(
              title: StringManager.deviceInspectionBaitCondition,
            ),
            SizedBox(
              height: 10.h,
            ),
            CustomDropDownMenu(),
            Divider(
              color: ColorManager.whiteColor,
            ),
            CustomText(
              title: StringManager.notes,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              'Nothing here yet',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Divider(
              color: ColorManager.whiteColor,
            ),
            Row(
              children: [
                CustomText(
                  title: StringManager.deviceInspectionRemoved,
                ),
                Checkbox(
                  activeColor: ColorManager.primaryColor,
                  value: _check,
                  onChanged: (val) {
                    setState(() {
                      _check = val;
                    });
                  },
                ),
              ],
            ),
            Divider(
              color: ColorManager.whiteColor,
            ),
            AddMaterial(title: StringManager.deviceInspectionAddMaterial,chooseList: materialsList,),
            AddMaterial(title: StringManager.deviceInspectionAddPest,chooseList: pestList,),
          ],
        ),
      ),
    );
  }
}

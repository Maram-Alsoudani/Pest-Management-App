import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/device_inspection/presentation/widgets/custom_text.dart';
import '../../../../Core/component/drop_down_menu_widget.dart';
import '../widgets/add_material.dart';

class DeviceInspection extends StatefulWidget {
  const DeviceInspection({super.key});

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
  List<String> conditions = ['Good', 'Ok', 'Bad'];
  String? selectedItem = 'Good';
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
                  title: '${StringManager.inspectionID} : $args',
                ),
                Text(
                  StringManager.deviceLastScan,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const Divider(
              color: ColorManager.whiteColor,
            ),
            CustomText(
              title: StringManager.inspectionDeviceCondition,
            ),
            SizedBox(
              height: 10.h,
            ),
            DropDownMenuWidget(
              list: conditions,
              selectedValue: selectedItem,
              onChange: (String? value) {
                selectedItem = value;
                setState(() {});
              },
            ),
            const Divider(
              color: ColorManager.whiteColor,
            ),
            CustomText(
              title: StringManager.inspectionDeviceCondition,
            ),
            DropDownMenuWidget(
              list: conditions,
              selectedValue: selectedItem,
              onChange: (String? value) {
                selectedItem = value;
                setState(() {});
              },
            ),
            SizedBox(
              height: 10.h,
            ),
            const Divider(
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
            const Divider(
              color: ColorManager.whiteColor,
            ),
            Row(
              children: [
                CustomText(
                  title: StringManager.inspectionRemoved,
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
            const Divider(
              color: ColorManager.whiteColor,
            ),
            AddMaterial(
              title: StringManager.inspectionAddMaterial,
              chooseList: materialsList,
            ),
            AddMaterial(
              title: StringManager.inspectionAddPest,
              chooseList: pestList,
            ),
          ],
        ),
      ),
    );
  }
}

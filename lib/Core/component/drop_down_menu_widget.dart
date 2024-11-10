
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/colors.dart';

class DropDownMenuWidget extends StatelessWidget {
  final List<String > list;
  final String ?selectedValue;
  final Function(String?) onChange;
  const DropDownMenuWidget({super.key, this.selectedValue, required this.onChange, required this.list});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(8.r),
      child: DropdownButtonFormField<String>(
        items: list.map((e) {
          return DropdownMenuItem<String>(
            value: e,
            child: Text(
              e,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          onChange(value);
        },
        value: selectedValue,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              color: ColorManager.whiteColor,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              color: ColorManager.whiteColor,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              color: ColorManager.whiteColor,
              width: 1,
            ),
          ),
        ),
        dropdownColor: ColorManager.backgroundColor,

        iconEnabledColor: ColorManager.whiteColor,
      ),
    );
  }
}

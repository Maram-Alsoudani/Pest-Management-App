import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/colors.dart';

class CustomDropDownMenu extends StatefulWidget {

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  List<String> conditions = ['Good', 'Ok', 'Bad'];
  String? selectedItem = 'Good';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.r),
          borderSide: BorderSide(color:ColorManager.primaryColor ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.r),
          borderSide: BorderSide(color:ColorManager.primaryColor ),
        ),
        fillColor: ColorManager.primaryColor,
        filled: true
      ),
      dropdownColor: ColorManager.primaryColor,
      iconEnabledColor: ColorManager.whiteColor,

      value: selectedItem,
      items: conditions.map((item)=>DropdownMenuItem<String>(
          value: item,
          child: Text(item,style: Theme.of(context).textTheme.titleSmall,))).toList(),
      onChanged: (item)=>setState(() {
        selectedItem = item;
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/register/domain/entities/user_model_entity.dart';
import 'package:bug_away/Features/site/presentation/manager/site_view_model.dart';

class UserDropdown extends StatefulWidget {
  const UserDropdown({super.key});

  @override
  _UserDropdownState createState() => _UserDropdownState();
}

class _UserDropdownState extends State<UserDropdown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: DropdownButtonFormField<UserAndAdminModelEntity>(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              width: 1,
              color: ColorManager.whiteColor,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              width: 1,
              color: ColorManager.greyShade6,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              width: 1,
              color: ColorManager.whiteColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              width: 1,
              color: ColorManager.primaryColor,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(
              width: 1,
              color: ColorManager.primaryColor,
            ),
          ),
        ),
        validator: (value) {
          if (value == null) {
            return StringManager.requiredField;
          }
          return null;
        },
        style: const TextStyle(color: ColorManager.whiteColor),
        dropdownColor: ColorManager.backgroundColor,
        hint: const Text(
          StringManager.selectUser,
          style: TextStyle(color: ColorManager.whiteColor),
        ),
        value: SiteViewModel.get(context).selectedValue,
        items: SiteViewModel.get(context).users.map((user) {
          return DropdownMenuItem<UserAndAdminModelEntity>(
            value: user,
            child: Text(user.userName ?? ""), // Replace 'name' with your field
          );
        }).toList(),
        onChanged: (UserAndAdminModelEntity? newValue) {
          setState(() {
            SiteViewModel.get(context).selectedValue = newValue!;
          });
        },
      ),
    );
  }
}

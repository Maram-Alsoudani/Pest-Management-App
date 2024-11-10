import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/firebase_utils.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/register/domain/entities/user_model_entity.dart';
import 'package:pesticides/Features/site/presentation/manager/site_state.dart';
import 'package:pesticides/Features/site/presentation/manager/site_view_model.dart';

import '../../../register/data/models/user_model_dto.dart';

class UserDropdown extends StatefulWidget {
  @override
  _UserDropdownState createState() => _UserDropdownState();
}

class _UserDropdownState extends State<UserDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<UserAndAdminModelEntity>(
      style: TextStyle(color: ColorManager.whiteColor),
      dropdownColor: ColorManager.backgroundColor,
      hint: Text(
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
    );
  }
}

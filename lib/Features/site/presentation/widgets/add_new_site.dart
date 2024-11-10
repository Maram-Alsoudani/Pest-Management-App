import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/theme/theming.dart';
import 'package:pesticides/Features/site/presentation/manager/site_state.dart';

import '../../../../Core/component/button_custom.dart';
import '../../../../Core/component/text_feild_custom.dart';
import '../../../../Core/component/validators.dart';
import '../../../../Core/utils/colors.dart';
import '../../../../Core/utils/firebase_utils.dart';
import '../manager/site_view_model.dart';
import 'custom_drop_down_menu.dart';

class AddNewSite extends StatefulWidget {
  const AddNewSite({super.key});

  @override
  State<AddNewSite> createState() => _AddNewSiteState();
}

class _AddNewSiteState extends State<AddNewSite> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorManager.backgroundColor,
      title: Text(
        'Add Site',
        style: TextStyle(color: ColorManager.whiteColor),
      ),
      content: Form(
        key: SiteViewModel.get(context).fromKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
                hint: 'Site Name',
                validator: (val) => AppValidators.validateSite(val),
                controller: SiteViewModel.get(context).siteNameController),
            CustomTextFormField(
                hint: 'Site Location',
                validator: (val) => AppValidators.validateSite(val),
                controller: SiteViewModel.get(context).siteLocationController),
            SizedBox(
                width: 232.w,
                child: UserDropdown()),
            ButtonCustom(
              onTap: () async {
                if (SiteViewModel.get(context)
                        .fromKey
                        .currentState!
                        .validate() &&
                    SiteViewModel.get(context).selectedValue != null) {
                  SiteViewModel.get(context).addSite();
                  SiteViewModel.get(context).clearDate();
                  Navigator.pop(context);
                  SiteViewModel.get(context).fetchSite();
                }
              },
              buttonName: 'Add Site',
            )
          ],
        ),
      ),
    );
  }
}

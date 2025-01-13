import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Features/category/profile/presentation/manager/profile_cubit.dart';

import '../../../../../Core/component/button_custom.dart';
import '../../../../../Core/component/text_feild_custom.dart';
import '../../../../../Core/component/validators.dart';
import '../../../../../Core/utils/colors.dart';
import '../../../../../Core/utils/strings.dart';

class EditProfileDialog extends StatelessWidget {
  const EditProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: ProfileCubit.get(context),
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: ColorManager.backgroundColor,
          title: Text(
            StringManager.editProfile,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontSize: 24.sp),
          ),
          content: Form(
            key: ProfileCubit.get(context).dialogFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8.h),
                CustomTextFormField(
                  hint: StringManager.userName,
                  validator: (val) => AppValidators.validateUsername(val),
                  controller: ProfileCubit.get(context).userNameController,
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  hint: StringManager.phone,
                  validator: (val) => AppValidators.validatePhoneNumber(val),
                  controller: ProfileCubit.get(context).phoneController,
                ),
                SizedBox(height: 8.h),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(StringManager.cancel,
                  style: Theme.of(context).textTheme.titleSmall),
            ),
            ButtonCustom(
              buttonName: StringManager.save,
              onTap: () {
                // Validate the dialog form before proceeding
                if (ProfileCubit.get(context)
                    .dialogFormKey
                    .currentState!
                    .validate()) {
                  ProfileCubit.get(context).editDataUser(); // Update user data
                  Navigator.pop(context); // Close dialog
                }
              },
            ),
          ],
        );
      },
    );
  }
}

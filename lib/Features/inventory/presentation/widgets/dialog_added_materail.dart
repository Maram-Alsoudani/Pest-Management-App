import 'package:bug_away/Features/inventory/domain/entities/materail_enitiy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/component/button_custom.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/inventory/presentation/manager/inventory_view_model_cubit.dart';

import '../../../../Core/component/text_feild_custom.dart';
import 'quantity_unit_widget.dart';

class AddedOrEditMaterailDialog extends StatelessWidget {
  final String buttonName;
  final String title;
  final Function onTap;
  final MaterailEntity? materail;

  const AddedOrEditMaterailDialog({
    super.key,
    required this.buttonName,
    required this.title,
    required this.onTap,
    this.materail,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = InventoryViewModelCubit.get(context);

    if (materail != null) {
      cubit.nameController.text = materail!.name ?? '';
      cubit.quantityController.text = materail!.quantity?.toString() ?? '';
      cubit.unit = materail!.unit;
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      backgroundColor: ColorManager.backgroundColor,
      child: Container(
        width: 340.w,
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 24.sp),
              ),
            ),
            SizedBox(height: 8.h),
            Form(
              key: cubit.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextFormField(
                    hint: StringManager.name,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return StringManager.enterMaterialName;
                      }
                      return null;
                    },
                    controller: cubit.nameController,
                  ),
                  SizedBox(height: 8.h),
                  const QuantityUnitField(),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    cubit.clearFields();
                    Navigator.pop(context);
                  },
                  child: Text(StringManager.cancel,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: ColorManager.dialogRedColor,
                          )),
                ),
                ButtonCustom(
                  buttonName: buttonName,
                  onTap: () {
                    if (cubit.formKey.currentState!.validate()) {
                      onTap();
                      cubit.clearFields();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

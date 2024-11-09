import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/component/button_custom.dart';
import 'package:pesticides/Core/component/text_feild_custom.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/category/profile/presentation/manager/profile_cubit.dart';
import 'package:pesticides/Features/inventory/presentation/manager/inventory_view_model_cubit.dart';



class AddedOrEditMaterailDialog extends StatelessWidget {
  final String buttonName;
  final String title;
  final Function onTap;

  const AddedOrEditMaterailDialog({super.key, required this.buttonName, required this.title, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: ProfileCubit.get(context),
      builder: (context, state) {
        return AlertDialog(
          backgroundColor: ColorManager.backgroundColor,
          title: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontSize: 24.sp),
          ),
          content: Form(
            key: InventoryViewModelCubit.get(context)
                .formKey, // Assign the dialog-specific form key here
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8.h),

                CustomTextFormField(
                  hint: "name",
                  validator:  (val) {
                    if(val==null|| val.isEmpty  ){
                      return "Enter Your Materail";
                    }
                    return null;
                  },
                  controller: InventoryViewModelCubit.get(context).nameController,
                ),
                SizedBox(height: 8.h),
                CustomTextFormField(
                  keyboardType: TextInputType.number,
                  hint: "quantity",
                  validator: (val) {
                    if(val==null|| val.isEmpty  ){
                      return "Enter Your Quantity";
                    }
                    return null;
                  },
                  controller: InventoryViewModelCubit.get(context).quantityController,
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
              buttonName: buttonName,
              onTap: () {
                if (InventoryViewModelCubit.get(context).formKey.currentState!.validate()){
                  onTap();
                }

              },
            ),
          ],
        );
      },
    );
  }
}

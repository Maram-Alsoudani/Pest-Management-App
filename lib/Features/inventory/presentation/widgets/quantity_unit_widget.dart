import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/inventory/presentation/manager/inventory_view_model_cubit.dart';

class QuantityUnitField extends StatefulWidget {
  const QuantityUnitField({super.key});

  @override
  _QuantityUnitFieldState createState() => _QuantityUnitFieldState();
}

class _QuantityUnitFieldState extends State<QuantityUnitField> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          isFocused = hasFocus;
        });
      },
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.sp),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: StringManager.quantity,
                  hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: ColorManager.greyShade3,
                      ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: isFocused
                          ? ColorManager.primaryColor
                          : ColorManager.whiteColor,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(
                      color: ColorManager.primaryColor,
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
                style: const TextStyle(color: ColorManager.whiteColor),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return StringManager.enterQuantity;
                  }
                  if (int.tryParse(val) == null) {
                    return StringManager.enterValidNumber;
                  }
                  return null;
                },
                controller:
                    InventoryViewModelCubit.get(context).quantityController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(RegExp(r'^(0|[1-9]\d*)$')),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: DropdownButtonFormField<String>(
                hint: Text(StringManager.unit,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: ColorManager.greyShade3)),
                value: InventoryViewModelCubit.get(context).unit,
                items: ['Pairs', 'Units', 'Kg', 'Liters']
                    .map((unit) => DropdownMenuItem(
                          value: unit,
                          child: Text(unit,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(color: ColorManager.whiteColor)),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    InventoryViewModelCubit.get(context).unit = value!;
                  });
                },
                decoration: InputDecoration(
                  hintText: StringManager.unit,
                  hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: ColorManager.greyShade3,
                      ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: isFocused
                          ? ColorManager.primaryColor
                          : ColorManager.whiteColor,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(
                      color: ColorManager.primaryColor,
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
                style: const TextStyle(color: ColorManager.whiteColor),
                dropdownColor: ColorManager.backgroundColor,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return StringManager.selectUnit; // Return error message
                  }
                  return null;
                },
                iconEnabledColor: ColorManager.whiteColor,
                iconDisabledColor: ColorManager.whiteColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

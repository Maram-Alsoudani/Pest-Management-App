
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Features/inventory/presentation/pages/inventory_screen.dart';

class MaterailItem extends StatelessWidget {
  const MaterailItem({
    super.key,
    required this.isUnavailable,
    required this.item,
  });

  final bool isUnavailable;
  final Map<String,dynamic> item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0.r),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0.r),
        child: Container(
          decoration: BoxDecoration(
            color: isUnavailable
                ? ColorManager.greyShade4
                : ColorManager.whiteColor,
            borderRadius: BorderRadius.circular(16.0.r),
          ),
          child: ListTile(
            leading: Icon(
              isUnavailable
                  ? CupertinoIcons.nosign
                  : CupertinoIcons.drop_triangle,
              color: ColorManager.primaryColor,
            ),
            title: Text(
              item["name"],
              style: TextStyle(
                fontSize: 20.sp,
                color: isUnavailable
                    ? ColorManager.greyShade3
                    : Colors.black,
                decoration: isUnavailable
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            trailing: Text('Quantity: ${item["quantity"].toString()}'),
          ),
        ),
      ),
    );
  }
}

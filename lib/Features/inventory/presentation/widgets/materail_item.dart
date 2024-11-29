import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/inventory/domain/entities/materail_enitiy.dart';

class MaterailItem extends StatelessWidget {
  const MaterailItem({
    super.key,
    required this.isUnavailable,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final bool isUnavailable;
  final MaterailEntity item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0.r),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.0.r),
        child: Container(
          decoration: BoxDecoration(
            color: isUnavailable
                ? ColorManager.greyShade4
                : ColorManager.whiteColor,
            borderRadius: BorderRadius.circular(22.0.r),
          ),
          child: Slidable(
            key: ValueKey(item.id),
            startActionPane: ActionPane(
                extentRatio: .20,
                motion: const BehindMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) => onEdit(),
                    backgroundColor: ColorManager.greyShade4,
                    foregroundColor: ColorManager.whiteColor,
                    icon: Icons.edit,
                  ),
                ]),
            endActionPane: ActionPane(
              extentRatio: .20,
              motion: const BehindMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => onDelete(),
                  backgroundColor: ColorManager.primaryColor,
                  foregroundColor: ColorManager.whiteColor,
                  icon: Icons.delete,
                ),
              ],
            ),
            child: ListTile(
              leading: Icon(
                isUnavailable
                    ? CupertinoIcons.nosign
                    : CupertinoIcons.drop_triangle,
                color: ColorManager.primaryColor,
              ),
              title: Text(
                item.name ?? "",
                style: TextStyle(
                  fontSize: 20.sp,
                  color: isUnavailable ? ColorManager.greyShade3 : Colors.black,
                  decoration: isUnavailable
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              trailing: Text('Quantity: ${item.quantity.toString()}'),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Features/inventory/domain/entities/materail_enitiy.dart';

class MaterailItem extends StatelessWidget {
  const MaterailItem({
    super.key,
    required this.isUnavailable,
    required this.item,
    required this.isAdmin,
    required this.onEdit,
    required this.onDelete,
    required this.onIncrement,
    required this.onDecrement,
  });

  final bool isUnavailable;
  final MaterailEntity item;
  final bool isAdmin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Slidable(
          key: ValueKey(item.id),
          startActionPane: isAdmin
              ? ActionPane(
                  motion: const StretchMotion(),
                  extentRatio: 0.20,
                  children: [
                    SlidableAction(
                      onPressed: (context) => onEdit?.call(),
                      backgroundColor: ColorManager.greyShade5,
                      foregroundColor: ColorManager.whiteColor,
                      icon: Icons.edit,
                    ),
                  ],
                )
              : null,
          endActionPane: isAdmin
              ? ActionPane(
                  motion: const StretchMotion(),
                  extentRatio: 0.20,
                  children: [
                    SlidableAction(
                      onPressed: (context) => onDelete?.call(),
                      backgroundColor: ColorManager.primaryColor,
                      foregroundColor: ColorManager.whiteColor,
                      icon: Icons.delete,
                    ),
                  ],
                )
              : null,
          child: Container(
            color: isUnavailable
                ? ColorManager.greyShade4
                : ColorManager.whiteColor,
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Icon(
                  isUnavailable
                      ? CupertinoIcons.nosign
                      : CupertinoIcons.drop_triangle,
                  color: ColorManager.primaryColor,
                ),
              ),
              title: Text(
                item.name ?? '',
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.w900,
                      decoration: isUnavailable
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
              ),
              subtitle: Text(
                '${item.unit}',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: ColorManager.greyShade5,
                    ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: isAdmin && item.quantity! > 0,
                    maintainSize: isAdmin ? true : false,
                    maintainAnimation: isAdmin ? true : false,
                    maintainState: isAdmin ? true : false,
                    child: IconButton(
                      icon: Icon(Icons.remove_circle,
                          size: 20.sp, color: ColorManager.primaryColor),
                      onPressed: onDecrement,
                    ),
                  ),
                  SizedBox(
                    width: 40.w,
                    child: Center(
                      child: Text(
                        '${item.quantity}',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: ColorManager.blackColor),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isAdmin && item.quantity! < 9999,
                    maintainSize: isAdmin ? true : false,
                    maintainAnimation: isAdmin ? true : false,
                    maintainState: isAdmin ? true : false,
                    child: IconButton(
                      icon: Icon(Icons.add_circle,
                          size: 20.sp, color: ColorManager.primaryColor),
                      onPressed: onIncrement,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

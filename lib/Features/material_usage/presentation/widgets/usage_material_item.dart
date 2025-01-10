import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Features/inventory/data/models/materail_model_dto.dart';

class MaterialUsageItem extends StatelessWidget {
  const MaterialUsageItem({
    super.key,
    required this.isUnavailable,
    required this.item,
    required this.availableQuantity,
    required this.selectedQuantity,
    required this.unit,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  final bool isUnavailable;
  final MaterailModelDto item;
  final int availableQuantity;
  final int selectedQuantity;
  final String unit;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Slidable(
          key: ValueKey(item.name),
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            extentRatio: 0.20,
            children: [
              SlidableAction(
                onPressed: (context) => onDelete(),
                backgroundColor: ColorManager.primaryColor,
                foregroundColor: ColorManager.whiteColor,
                icon: Icons.delete,
              ),
            ],
          ),
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
                unit,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: ColorManager.greyShade5,
                    ),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: selectedQuantity > 0,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    child: IconButton(
                      icon: Icon(Icons.remove_circle,
                          size: 20.sp, color: ColorManager.primaryColor),
                      onPressed: () {
                        if (selectedQuantity - 1 == 0) {
                          onDelete();
                        } else {
                          onDecrement();
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 40.w,
                    child: Center(
                      child: Text(
                        '$selectedQuantity',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: ColorManager.blackColor),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: selectedQuantity < availableQuantity,
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
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

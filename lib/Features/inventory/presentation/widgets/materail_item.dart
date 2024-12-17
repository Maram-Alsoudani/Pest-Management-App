import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/inventory/domain/entities/materail_enitiy.dart';

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
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

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
            startActionPane: onEdit != null
                ? ActionPane(
                    extentRatio: .20,
                    motion: const BehindMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => onEdit?.call(),
                        icon: Icons.edit,
                        backgroundColor: ColorManager.primaryColor,
                      ),
                    ],
                  )
                : null,
            endActionPane: onDelete != null
                ? ActionPane(
                    extentRatio: .20,
                    motion: const BehindMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => onDelete?.call(),
                        icon: Icons.delete,
                        backgroundColor: ColorManager.redColor,
                      ),
                    ],
                  )
                : null,
            child: ListTile(
              leading: const Icon(
                Icons.inventory,
                color: ColorManager.primaryColor,
              ),
              title: Text(
                item.name ?? '',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              trailing: Text('Quantity: ${item.quantity.toString()}'),
            ),
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Features/category/data/models/category_model.dart';

import '../../../../Core/utils/font_manager.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel categoryModel;
  const CategoryItem({super.key,required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      width: 200.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: ColorManager.whiteColor
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(categoryModel.image,
          width: 130.w,
            height: 150.h,
          ),
          Text(
            categoryModel.name,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(
                fontSize: FontSize.s20.sp,
              color: ColorManager.blackColor
            ),
          ),
        ],
      ),
    );
  }
}

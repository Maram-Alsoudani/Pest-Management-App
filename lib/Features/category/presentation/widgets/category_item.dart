import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Features/category/data/models/category_model.dart';
import '../../../../Core/utils/images.dart';
import '../../../../Core/utils/font_manager.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel categoryModel;
  final bool isLarge;

  const CategoryItem(
      {super.key, required this.categoryModel, this.isLarge = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(13.r),
      height: isLarge ? 250.h : 200.h,
      width: isLarge ? 300.w : 150.w,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(26.r),
        image: const DecorationImage(
          image: AssetImage(ImageManager.catBackground2),
          opacity: 0.9,
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            categoryModel.image,
            width: isLarge ? 270.w : 100.w,
            height: isLarge ? 115.h : 95.h,
          ),
          SizedBox(height: 10.h),
          Text(
            categoryModel.name,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: FontSize.s20.sp, color: ColorManager.blackColor),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

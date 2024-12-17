import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';

class SearchFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;

  const SearchFieldWidget({
    super.key,
    required this.controller,
    this.hintText = StringManager.searchHint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: ColorManager.whiteColor),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: ColorManager.whiteColor),
          prefixIcon: const Icon(Icons.search, color: ColorManager.whiteColor),
          filled: true,
          fillColor: ColorManager.greyShade6,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26.r),
            borderSide: BorderSide(
              color: ColorManager.whiteColor.withValues(alpha: 0.5),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(26.r),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),
        ),
      ),
    );
  }
}

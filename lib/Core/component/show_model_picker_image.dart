import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'dart:io' show Platform;

class ShowModelPickerImage extends StatefulWidget {
  final Function uploadImage2Screen;
  ShowModelPickerImage({super.key, required this.uploadImage2Screen});

  @override
  State<ShowModelPickerImage> createState() => _ShowModelPickerImageState();
}

class _ShowModelPickerImageState extends State<ShowModelPickerImage> {
  Future<void> _pickImage(ImageSource source) async {
    if (mounted) {
      Navigator.of(context).pop();
    }
    await widget.uploadImage2Screen(source);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    final TextStyle textStyle = TextStyle(
      fontSize: 17.sp,
      fontWeight: FontWeight.w500,
      color: isDarkMode ? ColorManager.whiteColor : ColorManager.blackColor,
    );

    final Color iconColor =
        isDarkMode ? ColorManager.whiteColor : ColorManager.blackColor;

    final Color backgroundColor = isDarkMode
        ? ColorManager.blackColor.withOpacity(0.8)
        : ColorManager.whiteColor.withOpacity(0.8);

    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoTheme(
        data: CupertinoThemeData(
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
          primaryColor:
              isDarkMode ? ColorManager.whiteColor : ColorManager.blueColor,
          scaffoldBackgroundColor: Colors.transparent,
        ),
        child: CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text(
                StringManager.takePhoto,
                style: textStyle.copyWith(color: ColorManager.dialogBlueColor),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text(
                StringManager.chooseFromGallery,
                style: textStyle.copyWith(color: ColorManager.dialogBlueColor),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              if (mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Text(
              StringManager.cancel,
              style: textStyle.copyWith(color: ColorManager.dialogRedColor),
            ),
          ),
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(22.r),
        height: 220.h,
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => _pickImage(ImageSource.camera),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.camera,
                    size: 28.sp,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: 11.w,
                  ),
                  Text(
                    StringManager.takePhoto,
                    style: textStyle,
                  ),
                ],
              ),
            ),
            Divider(
              color: isDarkMode
                  ? ColorManager.whiteColor.withOpacity(0.2)
                  : ColorManager.blackColor.withOpacity(0.2),
              thickness: 0.6,
            ),
            InkWell(
              onTap: () => _pickImage(ImageSource.gallery),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.photo,
                    size: 28.sp,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: 11.w,
                  ),
                  Text(
                    StringManager.chooseFromGallery,
                    style: textStyle,
                  ),
                ],
              ),
            ),
            Divider(
              color: isDarkMode
                  ? ColorManager.whiteColor.withOpacity(0.2)
                  : ColorManager.blackColor.withOpacity(0.2),
              thickness: 0.6,
            ),
            InkWell(
              onTap: () {
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.clear,
                    size: 28.sp,
                    color: iconColor,
                  ),
                  SizedBox(
                    width: 11.w,
                  ),
                  Text(
                    StringManager.cancel,
                    style: textStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

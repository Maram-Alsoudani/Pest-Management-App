import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'image_profile.dart';
import 'show_model_picker_image.dart';

class PickImageWidget extends StatefulWidget {
  final IconData icon;
  final String? imageUrl;
  final File? imagePath;
  final Function(ImageSource) onImagePicked;

  PickImageWidget({
    super.key,
    required this.icon,
    this.imageUrl,
    this.imagePath,
    required this.onImagePicked,
  });

  @override
  State<PickImageWidget> createState() => _PickImageWidgetState();
}

class _PickImageWidgetState extends State<PickImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: ColorManager.greyShade4,
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          widget.imageUrl == null
              ? widget.imagePath == null
                  ? ImageProfile(
                      radius: 71.r,
                    )
                  : GestureDetector(
                      onTap: () => viewImage(widget.imageUrl!),
                      child: ClipOval(
                        child: Image.file(
                          widget.imagePath!,
                          width: 145.w,
                          height: 145.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
              : GestureDetector(
                  onTap: () => viewImage(widget.imageUrl!),
                  child: ClipOval(
                    child: Image.network(
                      widget.imageUrl!,
                      width: 145.w,
                      height: 145.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          Positioned(
            right: 125.w,
            bottom: -15.h,
            child: IconButton(
                onPressed: () {
                  showImagePickerDialog(context);
                },
                icon: Icon(widget.icon),
                color: ColorManager.whiteColor),
          ),
        ],
      ),
    );
  }

  void showImagePickerDialog(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.transparent,
            child: ShowModelPickerImage(
              uploadImage2Screen: widget.onImagePicked,
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ShowModelPickerImage(
            uploadImage2Screen: widget.onImagePicked,
          );
        },
      );
    }
  }

  void viewImage(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.network(imageUrl),
          ),
        );
      },
    );
  }
}

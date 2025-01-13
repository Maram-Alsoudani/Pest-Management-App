import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import the package
import '../../../../../Core/component/image_profile.dart';
import '../../../../../Core/component/show_model_picker_image.dart';

class PickImageWidget extends StatefulWidget {
  final IconData icon;
  final String? imageUrl;
  final File? imagePath;
  final Function(ImageSource) onImagePicked;

  const PickImageWidget({
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
      width: 150.w,
      height: 150.h,
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: ColorManager.greyShade4,
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          if (widget.imageUrl == null && widget.imagePath == null)
            ImageProfile(radius: 71.r)
          else if (widget.imagePath != null)
            GestureDetector(
              onTap: () {
                viewImage(widget.imagePath!.path);
              },
              child: ClipOval(
                child: Image.file(
                  widget.imagePath!,
                  width: 145.w,
                  height: 145.h,
                  fit: BoxFit.cover,
                ),
              ),
            )
          else if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
            GestureDetector(
              onTap: () {
                viewImage(widget.imageUrl!);
              },
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl!,
                  width: 145.w,
                  height: 145.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                      child:
                          CircularProgressIndicator()), // Placeholder while loading
                  errorWidget: (context, url, error) =>
                      ImageProfile(radius: 70.r), // Error widget if image fails
                ),
              ),
            )
          else
            ImageProfile(radius: 71.r),
          Positioned(
            right: -8.5,
            bottom: -8.5,
            child: IconButton(
              onPressed: () {
                showImagePickerDialog(context);
              },
              icon: Icon(widget.icon),
              color: ColorManager.whiteColor,
            ),
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
            clipBehavior: Clip.none,
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

  void viewImage(String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: imagePath.startsWith('http')
                ? GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: CachedNetworkImage(
                      imageUrl: imagePath,
                      errorWidget: (context, url, error) {
                        return const Center(
                            child:
                                FaIcon(FontAwesomeIcons.triangleExclamation));
                      },
                    ),
                  )
                : GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Image.file(
                      File(imagePath),
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                            child:
                                FaIcon(FontAwesomeIcons.triangleExclamation));
                      },
                    ),
                  ),
          ),
        );
      },
    );
  }
}

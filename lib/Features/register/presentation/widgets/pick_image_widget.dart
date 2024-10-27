import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/register/presentation/widgets/show_model_picker_image.dart';

import '../../../../Core/component/image_profile.dart';
import '../../../../Core/utils/colors.dart';

class PickImageWidget extends StatefulWidget {
  final IconData icon;
  const PickImageWidget({super.key, required this.icon});

  @override
  State<PickImageWidget> createState() => _PickImageWidgetState();
}

class _PickImageWidgetState extends State<PickImageWidget> {
  final ImagePicker picker = ImagePicker();
  File? image;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
    }
  }

  void showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(CupertinoIcons.camera),
                title: const Text(StringManager.takePhoto),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.photo_fill),
                title: const Text(StringManager.chooseFromGallery),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void viewImage(File image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Image.file(image),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(125, 78, 91, 110),
      ),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          image == null
              ? ImageProfile(
                  radius: 71.r,
                )
              : GestureDetector(
            onTap:() => viewImage(image!),
                child: ClipOval(
                    child: Image.file(
                      image!,
                      width: 145.w,
                      height: 145.h,
                      fit: BoxFit.cover,
                    ),
                  ),
              ),
          Positioned(
            left: 230.w,
            bottom: -10.h,
            child: IconButton(
              onPressed: () {
                // uploadImage2Screen();
                showImagePickerDialog();
              },
              icon: Icon(widget.icon),
              color: const Color.fromARGB(255, 94, 115, 128),
            ),
          ),
        ],
      ),
    );
  }
}

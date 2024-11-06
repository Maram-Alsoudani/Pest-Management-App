import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Core/utils/colors.dart';

class AddPhotosScreen extends StatefulWidget {
  @override
  _AddPhotosScreenState createState() => _AddPhotosScreenState();
}

class _AddPhotosScreenState extends State<AddPhotosScreen> {
  List<File> images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  void _showImagePickerDialog() {
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
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(CupertinoIcons.photo_fill),
                title: const Text(StringManager.chooseFromGallery),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _viewImage(File image) {
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
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          StringManager.addPhotos,
          style:
              Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 25.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: images.length+1 ,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                ),
                itemBuilder: (context, index) {
                  print("index: $index");
                  print("images.length: ${images.length}");
                  if (index == images.length) {
                    return GestureDetector(
                      onTap: _showImagePickerDialog,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorManager.whiteColor,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          CupertinoIcons.camera_viewfinder,
                          size: 50.sp,
                          color: ColorManager.primaryColor,
                        ),
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () => _viewImage(images[index]),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorManager.greyShade2,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Image.file(
                            images[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 16.0.h),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/component/show_model_picker_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bug_away/Features/site_report/presentation/manager/report_view_model.dart';

class AddPhotosScreen extends StatefulWidget {
  const AddPhotosScreen({super.key});

  @override
  _AddPhotosScreenState createState() => _AddPhotosScreenState();
}

class _AddPhotosScreenState extends State<AddPhotosScreen> {
  List<File> images = [];
  List<int> selectedIndices = [];
  bool isMultiSelectMode = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final reportViewModel = context.read<ReportViewModel>();
    images = reportViewModel.photos.map((path) => File(path)).toList();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        images.add(File(pickedFile.path));
      });
      final reportViewModel = context.read<ReportViewModel>();
      reportViewModel.updatePhotos(images.map((e) => e.path).toList());
    }
  }

  void _showImagePickerDialog() {
    if (Platform.isIOS || Platform.isMacOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.transparent,
            child: ShowModelPickerImage(
              uploadImage2Screen: _pickImage,
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ShowModelPickerImage(
            uploadImage2Screen: _pickImage,
          );
        },
      );
    }
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

  void toggleSelection(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
      isMultiSelectMode = selectedIndices.isNotEmpty;
    });
  }

  void deleteSelected() {
    setState(() {
      selectedIndices.sort((a, b) => b.compareTo(a));
      for (var index in selectedIndices) {
        images.removeAt(index);
      }
      selectedIndices.clear();
      isMultiSelectMode = false;
    });
    final reportViewModel = context.read<ReportViewModel>();
    reportViewModel.updatePhotos(images.map((e) => e.path).toList());
  }

  void selectAll() {
    setState(() {
      selectedIndices = List.generate(images.length, (index) => index);
      isMultiSelectMode = true;
    });
  }

  void clearAllSelected() {
    setState(() {
      selectedIndices.clear();
      isMultiSelectMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportViewModel = context.read<ReportViewModel>();

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          isMultiSelectMode
              ? '${selectedIndices.length} Selected'
              : StringManager.addPhotos,
          style:
              Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 25.sp),
        ),
        actions: isMultiSelectMode
            ? [
                IconButton(
                    icon: const Icon(Icons.select_all), onPressed: selectAll),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: deleteSelected,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: clearAllSelected,
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.save, color: ColorManager.whiteColor),
                  onPressed: () {
                    reportViewModel
                        .updatePhotos(images.map((e) => e.path).toList());
                    Navigator.pop(context);
                  },
                ),
              ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: images.length + 1,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                ),
                itemBuilder: (context, index) {
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
                    final isSelected = selectedIndices.contains(index);
                    return GestureDetector(
                      onTap: () {
                        if (isMultiSelectMode) {
                          toggleSelection(index);
                        } else {
                          _viewImage(images[index]);
                        }
                      },
                      onLongPress: () {
                        toggleSelection(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? ColorManager.primaryColor
                                : Colors.transparent,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(13
                              .r), // Slightly smaller radius to ensure border visibility
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

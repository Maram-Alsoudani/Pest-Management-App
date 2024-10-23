import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pesticides/Features/register/presentation/widgets/show_model_picker_image.dart';

import '../../../../Core/component/image_profile.dart';
import '../../../../Core/utils/colors.dart';

class PickImageWidget extends StatefulWidget {
 final  IconData icon;
  const PickImageWidget({super.key, required this.icon});

  @override
  State<PickImageWidget> createState() => _PickImageWidgetState();
}

class _PickImageWidgetState extends State<PickImageWidget> {
  File? imgPath;

  showmodel() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ShowModelPickerImage(
          uploadImage2Screen: uploadImage2Screen,
        );
      },
    );
  }

  uploadImage2Screen(ImageSource source) async {
    final pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);

        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return    Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromARGB(125, 78, 91, 110),
      ),
      child: Stack(
        children: [
          imgPath == null
              ?  ImageProfile(
            radius: 71.r,
          )
              : ClipOval(
            child: Image.file(
              imgPath!,
              width: 145,
              height: 145,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 99,
            bottom: -1,
            child: IconButton(
              onPressed: () {
                // uploadImage2Screen();
                showmodel();
              },
              icon:  Icon(widget.icon),
              color: const Color.fromARGB(255, 94, 115, 128),
            ),
          ),
        ],
      ),
    );
  }
}

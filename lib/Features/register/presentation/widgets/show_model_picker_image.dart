import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ShowModelPickerImage extends StatefulWidget {
 Function uploadImage2Screen;
   ShowModelPickerImage({super.key,required this.uploadImage2Screen});

  @override
  State<ShowModelPickerImage> createState() => _ShowModelPickerImageState();
}

class _ShowModelPickerImageState extends State<ShowModelPickerImage> {



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      height: 170,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              await widget.uploadImage2Screen(ImageSource.camera);
            },
            child: const Row(
              children: [
                Icon(
                  Icons.camera,
                  size: 30,
                ),
                SizedBox(
                  width: 11,
                ),
                Text(
                  "From Camera",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 22,
          ),
          GestureDetector(
            onTap: () {
              widget.uploadImage2Screen(ImageSource.gallery);
            },
            child: const Row(
              children: [
                Icon(
                  Icons.photo_outlined,
                  size: 30,
                ),
                SizedBox(
                  width: 11,
                ),
                Text(
                  "From Gallery",
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

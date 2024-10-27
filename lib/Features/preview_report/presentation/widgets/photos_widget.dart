
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/utils/strings.dart';

class PhotosWidget extends StatelessWidget {
  final double opacity;
  final Animation<Offset> position;
  const PhotosWidget({super.key, required this.opacity, required this.position});

  @override
  Widget build(BuildContext context) {
    return   Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedOpacity(
          duration: const Duration(seconds: 2),
          opacity: opacity,
          curve: Curves.easeIn,
          child: Text(StringManager.photos,
              style: Theme.of(context).textTheme.bodyLarge),
        ),
        SizedBox(
          height: 80.h, // Set the height for the horizontal ListView
          child: SlideTransition(
            position: position,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: 10,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.asset("assets/images/ins_logo.png")),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

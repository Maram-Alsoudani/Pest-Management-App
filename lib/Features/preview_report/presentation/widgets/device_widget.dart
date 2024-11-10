
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../Core/utils/strings.dart';

class DeviceWidget extends StatelessWidget {
  final double opacity;
  final Animation<Offset> position;
  const DeviceWidget({super.key, required this.opacity, required this.position});

  @override
  Widget build(BuildContext context) {
    return   Column(
      children: [
        AnimatedOpacity(
          duration: const Duration(seconds: 2),
          opacity: opacity,
          curve: Curves.easeIn,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(StringManager.device,
                  style: Theme.of(context).textTheme.bodyLarge),
              Text("ID:BG 12",
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        SlideTransition(
          position: position,
          child: Column(
            children: [
              Row(
                children: [
                  Text("Device Conditions: ",
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text("GOOD",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 15.sp
                      )),
                ],
              ),
              Row(
                children: [
                  Text("Bait Conditions: ",
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text("GOOD",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 15.sp
                      )),
                ],
              ),
              Row(
                children: [
                  Text("Removed: ",
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text("NO",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 15.sp
                      )),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

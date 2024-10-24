import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/strings.dart';

import '../../../../Core/utils/colors.dart';

class NotesScreen extends StatefulWidget {
  NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with SingleTickerProviderStateMixin {
  final int maxCharacters = 500;
  String inputText = '';

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _slideAnimation =
        Tween<Offset>(begin:  Offset(0, 2.h), end: const Offset(0, 0)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    // Trigger the slide animation after the page loads
    Future.delayed(const Duration(milliseconds: 300), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // Clean up the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrefour",  style: Theme.of(context)
            .textTheme
            .titleSmall!
            .copyWith(fontSize: 25.sp)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.check,
                  size: 35.sp, color: ColorManager.primaryColor),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SlideTransition(
              position: _slideAnimation,
              child: TextField(
                maxLength: maxCharacters,
                onChanged: (text) {
                  setState(() {
                    inputText = text;
                  });
                },
                cursorColor: ColorManager.primaryColor,
                decoration: InputDecoration(
                  focusColor: ColorManager.greyShade5,
                  filled: true,
                  fillColor: ColorManager.whiteColor,
                  hintText: StringManager.enter_notes,
                  hintStyle: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: ColorManager.greyShade4),
                  counterStyle: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(color: ColorManager.greyShade4),
                ),
                maxLines: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/component/button_custom.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/register/presentation/widgets/pick_image_widget.dart';

import '../../../../Core/component/dialog_model.dart';
import '../../../../Core/component/text_feild_custom.dart';
import '../../../../Core/component/validators.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  double _opacity = 0.0;

  var fromKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    // Define the slide animation from the left to its original position
    _slideAnimation =
        Tween<Offset>(begin: Offset(-1.w, 0), end: Offset(0, 0)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    // Trigger the slide animation after the page loads
    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });
      _animationController.forward(); // Start the slide animation
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                DialogUtils.showMessage(
                  context: context,
                  color: ColorManager.backgroundColor,
                  content: "Are You Sure?",
                  title: "LogOut",
                  button1Name: "No",
                  button2Name: "Yes",
                );
              },
              icon: Icon(
                Icons.logout,
                color: ColorManager.primaryColor,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/your_background_image.png'), // Replace with your image path
                  fit: BoxFit.cover, // Cover the entire screen
                ),
              ),
            ),
            // Overlay content
            SingleChildScrollView(
              child: Form(
                key: fromKey,
                child: Column(
                  children: [
                    SizedBox(height: 65.h),
                    AnimatedOpacity(
                      duration: Duration(seconds: 2),
                      opacity: _opacity,
                      curve: Curves.easeIn,
                      child: PickImageWidget(
                        icon: Icons.edit,
                      ),
                    ),
                    SizedBox(height: 35.h),
                    SlideTransition(
                      position: _slideAnimation,
                      child: CustomTextFormField(
                        hint: StringManager.userName,
                        validator: (val) => AppValidators.validateUsername(val),
                        isSecured: false,
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.edit,
                            color: ColorManager.greyShade1,
                          ),
                        ),
                        controller: userNameController,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SlideTransition(
                      position: _slideAnimation,
                      child: CustomTextFormField(
                        hint: StringManager.phone,
                        validator: (val) => AppValidators.validatePhoneNumber(val),
                        isSecured: false,
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.edit,
                            color: ColorManager.greyShade1,
                          ),
                        ),
                        controller: phoneController,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SlideTransition(
                      position: _slideAnimation,
                      child: CustomTextFormField(
                        hint: StringManager.email,
                        validator: (val) => AppValidators.validateEmail(val),
                        isSecured: false,
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.edit,
                            color: ColorManager.greyShade1,
                          ),
                        ),
                        controller: emailController,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SlideTransition(
                      position: _slideAnimation,
                      child: CustomTextFormField(
                        hint: StringManager.password,
                        validator: (val) => AppValidators.validatePassword(val),
                        isSecured: false,
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.edit,
                            color: ColorManager.greyShade1,
                          ),
                        ),
                        controller: passwordController,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    SlideTransition(
                      position: _slideAnimation,
                      child: ButtonCustom(
                        buttonName: StringManager.submit,
                        onTap: () {
                          if (fromKey.currentState!.validate()) {
                            // Handle the submission logic here
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

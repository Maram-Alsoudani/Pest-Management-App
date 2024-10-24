import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pesticides/Core/component/button_custom.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/images.dart';
import 'package:pesticides/Core/utils/strings.dart';

import '../../../../Core/component/text_feild_custom.dart';
import '../../../../Core/component/validators.dart';
import '../widgets/pick_image_widget.dart';
import '../widgets/show_model_picker_image.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController userNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  var fromKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  double _opacity = 0.0;
  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    // Define the slide animation from the left to its original position
    _slideAnimation =
        Tween<Offset>(begin:  Offset(-1.w, 0), end: const Offset(0, 0)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    // Trigger the slide animation after the page loads
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });


      _animationController.forward(); // Start the slide animation
    });
  }

  @override
  void dispose() {
    _animationController.dispose(); // Clean up the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageManager.background), // Replace with your image path
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
                      duration: const Duration(seconds: 2),
                      opacity: _opacity,
                      curve: Curves.easeIn,
                      child: const PickImageWidget(
                        icon: Icons.add_a_photo,
                      ),
                    ),
                    SizedBox(height: 35.h),
                    SlideTransition(
                      position: _slideAnimation,
                      child: CustomTextFormField(
                        hint: StringManager.userName,
                        validator: (val) => AppValidators.validateUsername(val),
                        controller: userNameController,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SlideTransition(
                      position: _slideAnimation,
                      child: CustomTextFormField(
                        hint: StringManager.phone,
                        validator: (val) => AppValidators.validatePhoneNumber(val),
                        controller: phoneController,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SlideTransition(
                      position: _slideAnimation,
                      child: CustomTextFormField(
                        hint: StringManager.email,
                        validator: (val) => AppValidators.validateEmail(val),
                        controller: emailController,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SlideTransition(
                      position: _slideAnimation,
                      child: CustomTextFormField(
                        hint: StringManager.password,
                        validator: (val) => AppValidators.validatePassword(val),
                        controller: passwordController,
                        isSecured: true,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SlideTransition(
                      position: _slideAnimation,
                      child: CustomTextFormField(
                        hint: StringManager.confirmPassword,
                        validator: (val) {
                          // Implement confirmation password validation logic here
                          return null; // Adjust as needed
                        },
                        controller: confirmPasswordController,
                        isSecured: true,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    SlideTransition(
                      position: _slideAnimation,
                      child: ButtonCustom(
                        buttonName: StringManager.register,
                        onTap: () {
                          if (fromKey.currentState!.validate()) {
                            // Handle registration logic here
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 30.h),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          RoutesManger.routeNameLogin,
                              (route) => false,
                        );
                      },
                      child: AnimatedOpacity(
                        duration: const Duration(seconds: 2),
                        opacity: _opacity,
                        curve: Curves.easeIn,
                        child: Text(
                          StringManager.already_have_an_account,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
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

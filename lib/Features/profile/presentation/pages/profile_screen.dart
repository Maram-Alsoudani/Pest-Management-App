import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/component/button_custom.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/register/presentation/widgets/pick_image_widget.dart';

import '../../../../Core/component/custom_dialog.dart';
import '../../../../Core/component/text_feild_custom.dart';
import '../../../../Core/component/validators.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  TextEditingController userNameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  var fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(

                onPressed: () {
                  DialogUtils.showAlertDialog(context: context,
                      title: "Logout",
                      message:  "Are You Sure?",
                      posActionTitle: "Yes",
                      negActionTitle: "No",
                      posAction: (){
                        Navigator.pushNamedAndRemoveUntil(context, RoutesManger.routeNameLogin, (route) => false,);
                      }

                  );
                },
                icon: Icon(
                  Icons.logout,
                  color: ColorManager.primaryColor,
                ))
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 65.h),
                    PickImageWidget(
                      icon: Icons.edit,
                    ),
                    SizedBox(height: 35.h),
                    CustomTextFormField(
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
                    SizedBox(height: 20.h),
                    CustomTextFormField(
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
                    SizedBox(height: 20.h),
                    CustomTextFormField(
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
                    SizedBox(height: 20.h),
                    CustomTextFormField(
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
                    SizedBox(height: 30.h),
                    ButtonCustom(
                      buttonName: StringManager.submit,
                      onTap: () {
                        if (fromKey.currentState!.validate()) {
                          // Handle the submission logic here
                        }
                      },
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

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

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController controller1 = TextEditingController();

  var fromKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Form(
            key: fromKey,
            child: Column(
              children: [
                SizedBox(
                  height: 65.h,
                ),
                PickImageWidget(
                  icon: Icons.add_a_photo,
                ),
                SizedBox(
                  height: 35.h,
                ),
                CustomTextFormField(
                  hint: StringManager.userName,
                  validator: (val)=>AppValidators.validateUsername(val),
      
                  controller: controller1,
                ),
                CustomTextFormField(
                  hint: StringManager.phone,
                  validator: (val)=>AppValidators.validatePhoneNumber(val),
      
                  controller: controller1,
                ),
                CustomTextFormField(
                  hint: StringManager.email,
                  validator: (val) => AppValidators.validateEmail(val),
                  controller: controller1,
                ),
                CustomTextFormField(
                  hint: StringManager.password,
                  validator:(val) => AppValidators.validatePassword(val),
      
                  controller: controller1,
                  isSecured: true,
                ),
                CustomTextFormField(
                  hint: StringManager.confirmPassword,
                  validator: (text) {},
                  controller: controller1,
                  isSecured: true,
                ),
                SizedBox(
                  height: 30.h,
                ),
                ButtonCustom(
                  buttonName: StringManager.register,
                  onTap: () {
                    if (fromKey.currentState!.validate()) {}
                  },
                ),
                SizedBox(
                  height: 30.h,
                ),



                GestureDetector(
            onTap: () {
      Navigator.pushNamedAndRemoveUntil(context, RoutesManger.routeNameLogin, (route) => false,);
      },
                  child: Text(
                    StringManager.already_have_an_account,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

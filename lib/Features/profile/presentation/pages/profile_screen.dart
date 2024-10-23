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

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController controller1 = TextEditingController();

  var fromKey = GlobalKey<FormState>();

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
                    button2Name: "Yes"
                  );
                },
                icon: Icon(
                  Icons.logout,
                  color: ColorManager.primaryColor,
                ))
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: fromKey,
            child: Column(
              children: [
                SizedBox(
                  height: 65.h,
                ),
                 PickImageWidget(
                  icon: Icons.edit,
                ),
                SizedBox(
                  height: 35.h,
                ),
                CustomTextFormField(
                  hint: StringManager.userName,
                  validator: (val) => AppValidators.validateUsername(val),
                  isSecured: false,
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: ColorManager.greyShade1,
                      )),
                  controller: controller1,
                ),
                CustomTextFormField(
                  hint: StringManager.phone,
                  validator: (val) => AppValidators.validatePhoneNumber(val),
                  isSecured: false,
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: ColorManager.greyShade1,
                      )),
                  controller: controller1,
                ),
                CustomTextFormField(
                  hint: StringManager.email,
                  validator: (val) => AppValidators.validateEmail(val),
                  isSecured: false,
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: ColorManager.greyShade1,
                      )),
                  controller: controller1,
                ),
                CustomTextFormField(
                  hint: StringManager.password,
                  validator: (val) => AppValidators.validatePassword(val),
                  isSecured: false,
                  suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: ColorManager.greyShade1,
                      )),
                  controller: controller1,
                ),
                SizedBox(
                  height: 30.h,
                ),
                ButtonCustom(
                  buttonName: StringManager.submit,
                  onTap: () {
                    if (fromKey.currentState!.validate()) {}
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

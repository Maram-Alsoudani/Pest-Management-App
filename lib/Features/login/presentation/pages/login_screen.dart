import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/component/button_custom.dart';
import 'package:pesticides/Core/component/text_feild_custom.dart';
import 'package:pesticides/Core/component/validators.dart';

import '../../../../Core/utils/images.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: 80.h),
                    Image.asset(
                      ImageManager.logoTeam,
                      height: 220.h,
                      width: 400.w,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(height: 50.h),
                    CustomTextFormField(
                        hint: "Email",
                        validator: (val) => AppValidators.validateEmail(val),
                        controller: emailController),
                    CustomTextFormField(
                      hint: "Password",
                      validator: (val) => AppValidators.validatePassword(val),
                      controller: passwordController,
                      isSecured: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot Password?",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    ButtonCustom(
                      buttonName: "Login",
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          //TODO Handle Logic
                        }
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, RoutesManger.routeNameRegister);
                    },
                    child: Text(
                      "Don't have an account? Sign Up Here",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/component/button_custom.dart';
import 'package:pesticides/Core/component/text_feild_custom.dart';
import 'package:pesticides/Core/component/validators.dart';

import '../../../../Core/utils/colors.dart';
import '../../../../Core/utils/images.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  double _opacity = 0.0;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _slideAnimation =
        Tween<Offset>(begin: Offset(-1.w, 0), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? type=ModalRoute.of(context)?.settings.arguments as String?;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      ImageManager.background),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 80.h),
                          AnimatedOpacity(
                            opacity: _opacity,
                            duration: Duration(seconds: 2),
                            curve: Curves.easeIn,
                            child: Image.asset(
                              ImageManager.logoTeam,
                              height: 220.h,
                              width: 400.w,
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          AnimatedOpacity(
                            duration: Duration(seconds: 2),
                            opacity: _opacity,
                            curve: Curves.easeIn,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 20.h),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RoutesManger.routeNameEngOwnerScreen);
                                },
                                child: Text(
                                  "Type: ${type??"Select Type Please "} ? Change From Here",
                                  style: type == null ?
                                  Theme.of(context).textTheme.titleSmall!.copyWith(
                                      color: ColorManager.yellowColor
                                  ):  Theme.of(context).textTheme.titleSmall
                                ),

                              ),
                            ),
                          ),
                          SlideTransition(
                            position: _slideAnimation,
                            child: CustomTextFormField(
                              enable: type == null?false:true,
                              hint: "Email",
                              validator: (val) =>
                                  AppValidators.validateEmail(val),
                              controller: emailController,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          SlideTransition(
                            position: _slideAnimation,
                            child: CustomTextFormField(
                              enable: type == null?false:true,
                              hint: "Password",
                              validator: (val) =>
                                  AppValidators.validatePassword(val),
                              controller: passwordController,
                              isSecured: true,
                            ),
                          ),
                          AnimatedOpacity(
                            duration: Duration(seconds: 2),
                            opacity: _opacity,
                            curve: Curves.easeIn,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, RoutesManger.routeNameForgotPassScreen);
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.h),
                          SlideTransition(
                            position: _slideAnimation,
                            child: ButtonCustom(
                              buttonName: "Login",
                              enable: type == null?false:true,
                              onTap:

                                  () {
                                if (formKey.currentState!.validate()) {
                                  //TODO: Handle Logic
                                }
                                Navigator.pushReplacementNamed(context,
                                    RoutesManger.routeNameCategoryScreen);
                              },
                            ),
                          ),
                        ],
                      ),
                      AnimatedOpacity(
                        duration: Duration(seconds: 2),
                        opacity: _opacity,
                        curve: Curves.easeIn,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, RoutesManger.routeNameRegister);
                            },
                            child: Text(
                              "Don't have an account? Sign Up Here",
                              style:

                              Theme.of(context).textTheme.titleSmall,
                            ),

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

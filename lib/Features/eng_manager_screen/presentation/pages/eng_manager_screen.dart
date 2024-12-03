import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/utils/SharedPrefsLocal.dart';
import 'package:pesticides/Core/utils/strings.dart';
import '../../../../Core/component/button_custom.dart';
import '../../../../Core/utils/images.dart';
import '../widget/custom_button.dart';

class EngManagerScreen extends StatefulWidget {
  @override
  State<EngManagerScreen> createState() => _EngManagerScreenState();
}

class _EngManagerScreenState extends State<EngManagerScreen>
    with SingleTickerProviderStateMixin {
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
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageManager.background),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content on top of the background image
          Padding(
            padding: const EdgeInsets.all(16.0), // Add some padding
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 50.h),
                  AnimatedOpacity(
                    opacity: _opacity,
                    duration: Duration(seconds: 2),
                    curve: Curves.easeIn,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26.0),
                      child: Image.asset(
                        ImageManager.logoTeam,
                        height: 200.h,
                        width: 180.w,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SlideTransition(
                        position: _slideAnimation,
                        child: CustomButton(
                          name: StringManager.eng,
                          backgroundImage: ImageManager.catBackground3,
                          boxImage: ImageManager.engIcon,
                          routeName: RoutesManger.routeNameLogin,
                          type: "user",
                        ),
                      ),
                      SlideTransition(
                        position: _slideAnimation,
                        child: CustomButton(
                          name: StringManager.manager,
                          backgroundImage: ImageManager.catBackground3,
                          boxImage: ImageManager.ownerIcon,
                          routeName: RoutesManger.routeNameLogin,
                          type: "admin",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 75.h),
                  SlideTransition(
                    position: _slideAnimation,
                    child: Center(
                      child: ButtonCustom(
                        buttonName: StringManager.requestAccount,
                        onTap: () {
                          Navigator.pushReplacementNamed(context,
                              RoutesManger.routeNameUserRequestAccount);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

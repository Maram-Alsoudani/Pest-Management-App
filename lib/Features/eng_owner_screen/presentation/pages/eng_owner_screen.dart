import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import '../../../../Core/utils/images.dart';
import '../widget/custom_button.dart';

class EngOwnerScreen extends StatefulWidget {
  @override
  State<EngOwnerScreen> createState() => _EngOwnerScreenState();
}

class _EngOwnerScreenState extends State<EngOwnerScreen> with SingleTickerProviderStateMixin {
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 50.h),
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
                SizedBox(
                  height: 30.h,
                ),
                SlideTransition(
                  position: _slideAnimation,
                  child: CustomButton(
                    name: 'Engineer',
                    image: ImageManager.engIcon,
                    routeName: RoutesManger.routeNameRegister,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                SlideTransition(
                  position: _slideAnimation,

                  child: CustomButton(
                    name: 'Administrator',
                    image: ImageManager.ownerIcon,
                    routeName: RoutesManger.routeNameLogin,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

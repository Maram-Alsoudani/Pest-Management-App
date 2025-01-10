import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Config/routes/routes_manger.dart';
import 'package:bug_away/Core/utils/strings.dart';
import '../../../../Core/component/button_custom.dart';
import '../../../../Core/utils/images.dart';
import '../widget/custom_button.dart';

class EngManagerScreen extends StatefulWidget {
  const EngManagerScreen({super.key});

  @override
  State<EngManagerScreen> createState() => _EngManagerScreenState();
}

class _EngManagerScreenState extends State<EngManagerScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Image _backgroundImage;
  late Image _catBackground3;
  late Image _engIcon;
  late Image _ownerIcon;

  @override
  void initState() {
    super.initState();

    _backgroundImage = Image.asset(ImageManager.background);
    _catBackground3 = Image.asset(ImageManager.catBackground3);
    _engIcon = Image.asset(ImageManager.engIcon);
    _ownerIcon = Image.asset(ImageManager.ownerIcon);

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _slideAnimation =
        Tween<Offset>(begin: Offset(-1.w, 0), end: const Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });
      _animationController.forward();
    });

    // Preload the images
    _preloadImages();
  }

  void _preloadImages() {
    _backgroundImage.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((_, __) {
        setState(() {});
      }),
    );
    _catBackground3.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((_, __) {
        setState(() {});
      }),
    );
    _engIcon.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((_, __) {
        setState(() {});
      }),
    );
    _ownerIcon.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((_, __) {
        setState(() {});
      }),
    );
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
            decoration: BoxDecoration(
              image: DecorationImage(
                image: _backgroundImage.image,
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
                    duration: const Duration(seconds: 2),
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
                        child: const CustomButton(
                          name: StringManager.engineer,
                          backgroundImage: ImageManager.catBackground3,
                          boxImage: ImageManager.engIcon,
                          routeName: RoutesManger.routeNameLogin,
                          type: "user",
                        ),
                      ),
                      SlideTransition(
                        position: _slideAnimation,
                        child: const CustomButton(
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

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Features/category/data/models/category_model.dart';

import '../../../../Core/component/dialog_model.dart';
import '../../../../Core/component/image_profile.dart';
import '../../../../Core/utils/colors.dart';
import '../../../../Core/utils/font_manager.dart';
import '../widgets/category_item.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Animation<Offset> _rowAnimation; // Animation for Row

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // Define the scale animation for GridView items
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Define the slide animation for Row
    _rowAnimation = Tween<Offset>(
      begin: Offset(-1, 0), // Start slightly below the visible area
      end: Offset(0, 0), // End at the original position
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Trigger the animation after the page loads
    Future.delayed(Duration(milliseconds: 200), () {
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
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
          child: Column(
            children: [
              SlideTransition( // SlideTransition for Row
                position: _rowAnimation,
                child: Row(
                  children: [
                    ImageProfile(
                      radius: 40.r,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mohamed Ali",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: FontSize.s24.sp),
                        ),
                        Text(
                          "Site Engineer",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    Spacer(),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.more_vert,
                        size: 38.r,
                      ),
                      onSelected: (String choice) {
                        if (choice == 'Profile') {
                          Navigator.pushNamed(context, RoutesManger.routeNameProfile);
                        } else if (choice == 'Log Out') {
                          // Log out logic here
                          DialogUtils.showMessage(
                            context: context,
                            color: ColorManager.backgroundColor,
                            content: "Are You Sure?",
                            title: "LogOut",
                            button1Name: "No",
                            button2Name: "Yes",
                            button2Function: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RoutesManger.routeNameLogin,
                                    (route) => false,
                              );
                            },
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return ['Profile', 'Log Out'].map((String choice) {
                          return PopupMenuItem<String>(
                            value: choice,
                            child: Text(choice),
                          );
                        }).toList();
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 130.h,
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: CategoryModel.images.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15.h,
                    crossAxisSpacing: 10.w,
                  ),
                  itemBuilder: (context, index) {
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(
                            index / CategoryModel.images.length, // Start based on the index
                            1.0,
                            curve: Curves.easeInOut,
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (index == 0) {
                            Navigator.pushNamed(context, RoutesManger.routeNameSites);
                          }
                        },
                        child: CategoryItem(
                          categoryModel: CategoryModel.images[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

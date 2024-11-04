import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/component/custom_dialog.dart';
import 'package:pesticides/Core/utils/SharedPrefsLocal.dart';
import 'package:pesticides/Features/category/data/models/category_model.dart';

import '../../../../Core/component/image_profile.dart';
import '../../../../Core/utils/font_manager.dart';
import '../../../../Core/utils/strings.dart';
import '../../../../Features/register/data/models/user_model_dto.dart';
import '../widgets/category_item.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _rowAnimation; // Animation for Row

  UserAndAdminModelDto? user;

  @override
  void initState() {
    super.initState();

    // Load user data
    user = SharedPrefsLocal.getData(key: StringManager.keyUserAdmin);

    // Initialize the AnimationController
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    // Define the slide animation for Row
    _rowAnimation = Tween<Offset>(
      begin: Offset(-1, 0), // Start slightly to the left
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
              SlideTransition(
                position: _rowAnimation,
                child: Row(
                  children: [
                    ImageProfile(
                      radius: 40.r,
                      imageUrl: user?.image,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.userName ?? StringManager.userName,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontSize: FontSize.s24.sp),
                        ),
                        Text(
                          user?.type ?? StringManager.role,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    Spacer(),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, size: 38.r),
                      onSelected: (String choice) {
                        if (choice == StringManager.profile) {
                          Navigator.pushNamed(
                              context, RoutesManger.routeNameProfile);
                        } else if (choice == StringManager.logout) {
                          DialogUtils.showAlertDialog(
                            context: context,
                            title: StringManager.logout,
                            message: StringManager.logoutMessage,
                            posActionTitle: StringManager.yes,
                            negActionTitle: StringManager.no,
                            posAction: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RoutesManger.routeNameLogin,
                                (route) => false,
                              );
                              FirebaseAuth.instance.signOut();
                              SharedPrefsLocal.prefs.clear();
                            },
                          );
                        }
                      },
                      itemBuilder: (BuildContext context) {
                        return [StringManager.profile, StringManager.logout]
                            .map((String choice) {
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
              SizedBox(height: 70.h),
              Expanded(
                child: ListView.builder(
                  itemCount: CategoryModel.images.length,
                  itemBuilder: (context, index) {
                    return ScaleTransition(
                      scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(
                            index /
                                CategoryModel
                                    .images.length, // Start based on index
                            1.0,
                            curve: Curves.easeInOut,
                          ),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          if (index == 0) {
                            Navigator.pushNamed(
                                context, RoutesManger.routeNameSites);
                          }
                          if (index == 1) {
                            Navigator.pushNamed(
                                context, RoutesManger.routeNamePreviewReport);
                          }
                          if (index == 2) {
                            Navigator.pushNamed(
                                context, RoutesManger.routeNameInventory);
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

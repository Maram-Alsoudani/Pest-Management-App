import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/component/custom_dialog.dart';
import 'package:pesticides/Features/category/data/models/category_model.dart';

import '../../../../Core/component/image_profile.dart';
import '../../../../Core/utils/font_manager.dart';
import '../widgets/category_item.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
          child: Column(
            children: [
              Row(
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
                      Text("Site Engineer",
                          style: Theme.of(context).textTheme.titleSmall),
                    ],
                  ),
                  Spacer(),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert,size: 38.r,),
                    onSelected: (String choice) {
                      if (choice == 'Profile') {
                        Navigator.pushNamed(context, RoutesManger.routeNameProfile);
                      } else if (choice == 'Log Out') {
                        // Log out logic here
                       DialogUtils.showAlertDialog(context: context,
                         title: "Logout",
                         message:  "Are You Sure?",
                         posActionTitle: "Yes",
                         negActionTitle: "No",
                         posAction: (){
                           Navigator.pushNamedAndRemoveUntil(context, RoutesManger.routeNameLogin, (route) => false,);
                         }

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
              SizedBox(
                height: 130.h,
              ),
              Expanded(
                  child: GridView.builder(
                itemCount: CategoryModel.images.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15.h,
                    crossAxisSpacing: 10.w),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      if (index == 0) {
                        Navigator.pushNamed(
                            context, RoutesManger.routeNameSites);
                      }
                    },
                    child: CategoryItem(
                      categoryModel: CategoryModel.images[index],
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}

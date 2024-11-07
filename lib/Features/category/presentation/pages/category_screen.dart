import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/component/custom_dialog.dart';
import 'package:pesticides/Core/utils/SharedPrefsLocal.dart';
import 'package:pesticides/Features/category/data/models/category_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:pesticides/Features/category/presentation/manager/category_cubit.dart';
import 'package:pesticides/Features/category/profile/presentation/pages/profile_screen.dart';

import '../../../../Core/component/image_profile.dart';
import '../../../../Core/component/lottie_loading_widget.dart';
import '../../../../Core/utils/colors.dart';
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
  late CategoryCubit bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<CategoryCubit>(context);
    bloc.getUserData();
    bloc.doAnimation(this);
  }

  @override
  dispose() {
    bloc.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<CategoryCubit, CategoryState>(
        listener: (context, state) {
          if (state is CategoryFaluireState) {
            DialogUtils.showAlertDialog(
                context: context,

                title: StringManager.failed,
                message: state.error.errorMessage,
                posActionTitle: StringManager.ok,
                posAction: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    RoutesManger.routeNameEngOwnerScreen,
                    (route) => false,
                  );
                  SharedPrefsLocal.prefs.clear();
                });
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            opacity: 0.2,
            color: ColorManager.greyShade3,
            inAsyncCall: bloc.isLoading,
            progressIndicator: const Center(child: LottieLoadingWidget()),
            child: Scaffold(
              body: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 25, horizontal: 10),
                  child: state is CategorySuccessState
                      ? Column(
                          children: [
                            SlideTransition(
                              position: bloc.slideAnimation,
                              child: Row(
                                children: [
                                  state.userAndAdminModelEntity.image != null &&
                                          state.userAndAdminModelEntity.image!
                                              .isNotEmpty
                                      ? CircleAvatar(
                                          radius: 40.r,
                                          backgroundColor: Colors.grey.shade200,
                                          backgroundImage:
                                              CachedNetworkImageProvider(state
                                                  .userAndAdminModelEntity
                                                  .image!),
                                        )
                                      : ImageProfile(
                                          radius: 40
                                              .r), // Replace with your fallback widget

                                  SizedBox(width: 20.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        state.userAndAdminModelEntity
                                                .userName ??
                                            "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .copyWith(
                                                fontSize: FontSize.s24.sp),
                                      ),
                                      Text(
                                        state.userAndAdminModelEntity.type ??
                                            "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_vert, size: 38.r),
                                    onSelected: (String choice) {
                                      if (choice == StringManager.profile) {
                                        Navigator.pushNamed(context,
                                            RoutesManger.routeNameProfile);
                                      } else if (choice ==
                                          StringManager.logout) {
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
                                      return [
                                        StringManager.profile,
                                        StringManager.logout
                                      ].map((String choice) {
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
                            SizedBox(height: 40.h),
                            Expanded(
                              child: ListView.builder(
                                itemCount: CategoryModel.images.length,
                                itemBuilder: (context, index) {
                                  return ScaleTransition(
                                    scale: Tween<double>(begin: 0.0, end: 1.0)
                                        .animate(
                                      CurvedAnimation(
                                        parent: bloc.animationController,
                                        curve: Interval(
                                          index /
                                              CategoryModel.images
                                                  .length, // Start based on index
                                          1.0,
                                          curve: Curves.easeInOut,
                                        ),
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (index == 0) {
                                          Navigator.pushNamed(context,
                                              RoutesManger.routeNameSites);
                                        }
                                        if (index == 1) {
                                          Navigator.pushNamed(
                                              context,
                                              RoutesManger
                                                  .routeNamePreviewReport);
                                        }
                                        if (index == 2) {
                                          Navigator.pushNamed(context,
                                              RoutesManger.routeNameInventory);
                                        }
                                      },
                                      child: CategoryItem(
                                        categoryModel:
                                            CategoryModel.images[index],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        )
                      : SizedBox()),
            ),
          );
        },
      ),
    );
  }
}

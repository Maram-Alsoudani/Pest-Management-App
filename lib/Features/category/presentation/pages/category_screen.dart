import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bug_away/Config/routes/routes_manger.dart';
import 'package:bug_away/Core/component/custom_dialog.dart';
import 'package:bug_away/Core/utils/SharedPrefsLocal.dart';
import 'package:bug_away/Features/category/data/models/category_model.dart';
import 'package:bug_away/Features/category/presentation/manager/category_cubit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../Core/component/image_profile.dart';
import '../../../../Core/component/lottie_loading_widget.dart';
import '../../../../Core/utils/colors.dart';
import '../../../../Core/utils/font_manager.dart';
import '../../../../Core/utils/images.dart';
import '../../../../Core/utils/strings.dart';
import '../../profile/presentation/manager/profile_cubit.dart';
import '../widgets/category_item.dart';
import '../widgets/drawer_widget.dart';

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
  void dispose() {
    bloc.animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryCubit, CategoryState>(
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
                  RoutesManger.routeNameLogin,
                  (route) => false,
                );
                SharedPrefsLocal.prefs.clear();
                FirebaseAuth.instance.signOut();
              });
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          opacity: 0.4,
          color: ColorManager.greyShade3,
          inAsyncCall: bloc.isLoading,
          progressIndicator: const Center(child: LottieLoadingWidget()),
          child: Stack(
            children: [
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
              SafeArea(
                child: Scaffold(
                  drawer: state is CategorySuccessState
                      ? DrawerWidget(
                          userName:
                              state.userAndAdminModelEntity.userName ?? "",
                          userImage: state.userAndAdminModelEntity.image,
                          userType: state.userAndAdminModelEntity.type ?? "",
                        )
                      : null,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    iconTheme: const IconThemeData(color: Colors.white),
                    leading: Builder(
                      builder: (context) => IconButton(
                        icon: const FaIcon(FontAwesomeIcons.barsStaggered),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.signOut,
                        ),
                        onPressed: () {
                          DialogUtils.showAlertDialog(
                            context: context,
                            title: StringManager.logout,
                            message: StringManager.logoutMessage,
                            posActionTitle: StringManager.ok,
                            negActionTitle: StringManager.cancel,
                            posAction: () async {
                              await ProfileCubit.get(context).removeFcmUser();
                              SharedPrefsLocal.prefs.clear();
                              FirebaseAuth.instance.signOut();
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                RoutesManger.routeNameLogin,
                                (route) => false,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  backgroundColor: Colors.transparent,
                  body: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 10),
                    child: state is CategorySuccessState
                        ? Column(
                            children: [
                              Column(
                                children: [
                                  state.userAndAdminModelEntity.image != null &&
                                          state.userAndAdminModelEntity.image!
                                              .isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50.r),
                                          child: CachedNetworkImage(
                                            width: 100.w,
                                            height: 100.h,
                                            fit: BoxFit.fill,
                                            imageUrl: state
                                                .userAndAdminModelEntity.image!,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                CircularProgressIndicator(
                                                    color: ColorManager
                                                        .primaryColor,
                                                    value: downloadProgress
                                                        .progress),
                                            errorWidget:
                                                (context, url, error) =>
                                                    ImageProfile(radius: 40.r),
                                          ),
                                        )
                                      : ImageProfile(radius: 40.r),
                                  SizedBox(height: 20.h),
                                  Text(
                                    state.userAndAdminModelEntity.userName ??
                                        "",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(fontSize: FontSize.s24.sp),
                                  ),
                                  Text(
                                    getDisplayUserType(
                                        state.userAndAdminModelEntity.type ??
                                            ""),
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              SizedBox(height: 40.h),
                              Expanded(
                                child: StaggeredGrid.count(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  children: List.generate(
                                    CategoryModel.images.length,
                                    (index) {
                                      return StaggeredGridTile.count(
                                        crossAxisCellCount: index == 2 ? 2 : 1,
                                        mainAxisCellCount: 1,
                                        child: InkWell(
                                          onTap: () {
                                            if (index == 0) {
                                              Navigator.pushNamed(context,
                                                  RoutesManger.routeNameSites);
                                            }
                                            if (index == 1) {
                                              var currentUser =
                                                  SharedPrefsLocal.getData(
                                                      key: StringManager
                                                          .userAdmin);
                                              if (currentUser!.type ==
                                                  'admin') {
                                                Navigator.pushNamed(
                                                    context,
                                                    RoutesManger
                                                        .routeNameReportsOfAllUsersForAdmin);
                                              } else if (currentUser.type ==
                                                  'user') {
                                                Navigator.pushNamed(
                                                    context,
                                                    RoutesManger
                                                        .routeNameSitesOfUserForAdmin,
                                                    arguments: currentUser.id);
                                              }
                                            }
                                            if (index == 2) {
                                              Navigator.pushNamed(
                                                  context,
                                                  RoutesManger
                                                      .routeNameInventory);
                                            }
                                          },
                                          child: CategoryItem(
                                            categoryModel:
                                                CategoryModel.images[index],
                                            isLarge: index ==
                                                2, // Make the third item large
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

String getDisplayUserType(String userType) {
  switch (userType.toLowerCase()) {
    case 'admin':
      return 'Admin';
    case 'user':
      return 'Engineer';
    default:
      return userType;
  }
}

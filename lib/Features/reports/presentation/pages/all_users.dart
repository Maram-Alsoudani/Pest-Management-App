import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bug_away/Config/routes/routes_manger.dart';
import 'package:bug_away/Features/reports/presentation/widgets/user_widget.dart';
import 'package:bug_away/di/di.dart';

import '../../../../Core/component/lottie_loading_widget.dart';
import '../../../../Core/component/text_feild_custom.dart';
import '../../../../Core/utils/colors.dart';
import '../../../../Core/utils/strings.dart';
import '../manager/all_users_screen_view_model.dart';
import '../manager/get_all_users_states.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers>
    with SingleTickerProviderStateMixin {
  AllUsersScreenViewModel allUsersViewModel = getIt<AllUsersScreenViewModel>();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allUsersViewModel.initializeAnimation(this);

    allUsersViewModel.getUsers();

    searchController.addListener(() {
      allUsersViewModel.searchUsers(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.reportsSubmittedBy),
      ),
      body: BlocBuilder<AllUsersScreenViewModel, GetAllUsersState>(
        bloc: allUsersViewModel,
        builder: (context, state) {
          return ModalProgressHUD(
            opacity: 0.4,
            color: ColorManager.greyShade3,
            inAsyncCall: allUsersViewModel.isLoading,
            progressIndicator: const Center(child: LottieLoadingWidget()),
            child: Column(
              children: [
                AnimatedOpacity(
                  duration: const Duration(seconds: 2),
                  opacity: allUsersViewModel.opacity,
                  curve: Curves.easeIn,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: CustomTextFormField(
                      hint: StringManager.searchHint,
                      controller: searchController,
                      validator: (value) {
                        return null;
                      },
                      borderRadius: BorderRadius.circular(26.0.r),
                    ),
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is GetAllUsersErrorState) {
                        return Center(
                          child: Text(
                            state.errorMessage,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (state is NoSearchResultsState) {
                        return Center(
                          child: Text(
                            StringManager.noSitesFound,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: ColorManager.greyShade4),
                          ),
                        );
                      } else {
                        return SlideTransition(
                          position: allUsersViewModel.slideAnimation,
                          child: Padding(
                            padding: EdgeInsets.all(15.sp),
                            child: ListView.builder(
                              itemCount: allUsersViewModel.allUsers.length,
                              itemBuilder: (context, index) {
                                final user = allUsersViewModel.allUsers[index];

                                return InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context,
                                        RoutesManger
                                            .routeNameSitesOfUserForAdmin,
                                        arguments: allUsersViewModel
                                            .allUsers[index].id);
                                  },
                                  child: UserWidget(
                                    imageUrl: user.image ??
                                        "assets/images/avatar.png",
                                    userName: user.userName ?? "Unknown User",
                                    email: user.email ?? "",
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

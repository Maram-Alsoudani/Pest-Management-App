import 'package:bug_away/Core/component/empty_pages.dart';
import 'package:bug_away/Core/component/search_field_widget.dart';
import 'package:bug_away/Core/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bug_away/Config/routes/routes_manger.dart';
import 'package:bug_away/Features/reports/presentation/widgets/user_widget.dart';
import 'package:bug_away/di/di.dart';

import '../../../../Core/component/lottie_loading_widget.dart';
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
  void dispose() {
    if (mounted) {
      searchController.dispose();
    }
    super.dispose();
  }

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
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(StringManager.reportsSubmittedBy),
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
                  child: SearchFieldWidget(
                    controller: searchController,
                    onChanged: (value) {
                      allUsersViewModel.searchUsers(value);
                    },
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is GetAllUsersErrorState) {
                        return const Center(
                          child: EmptyStateWidget(
                            lottiePath: ImageManager.emptySearchLottie,
                            message: StringManager.noUsersFound,
                          ),
                        );
                      } else if (state is NoSearchResultsState) {
                        return const Center(
                          child: EmptyStateWidget(
                            lottiePath: ImageManager.emptySearchLottie,
                            message: StringManager.noUsersFound,
                          ),
                        );
                      } else {
                        return SlideTransition(
                          position: allUsersViewModel.slideAnimation,
                          child: ListView.builder(
                            itemCount: allUsersViewModel.allUsers.length,
                            itemBuilder: (context, index) {
                              final user = allUsersViewModel.allUsers[index];

                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      RoutesManger.routeNameSitesOfUserForAdmin,
                                      arguments:
                                          allUsersViewModel.allUsers[index].id);
                                },
                                child: UserWidget(
                                  imageUrl: user.image ?? ImageManager.avatar,
                                  userName: user.userName ??
                                      StringManager.unknownUser,
                                  email: user.email ?? "",
                                ),
                              );
                            },
                          ),
                        );
                      }
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

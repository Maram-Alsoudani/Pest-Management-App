import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Features/register/data/models/user_model_dto.dart';
import 'package:pesticides/Features/site/presentation/manager/site_state.dart';
import 'package:pesticides/Features/site/presentation/manager/site_view_model.dart';

import '../../../../Core/component/custom_dialog.dart';
import '../../../../Core/component/lottie_loading_widget.dart';
import '../../../../Core/utils/strings.dart';
import '../widgets/add_new_site.dart';
import '../widgets/site_info_item.dart';

class SitesScreen extends StatefulWidget {
  SitesScreen({super.key});

  @override
  State<SitesScreen> createState() => _SitesScreenState();
}

class _SitesScreenState extends State<SitesScreen>
    with SingleTickerProviderStateMixin {
  late SiteViewModel bloc;

  @override
  void initState() {
    bloc = SiteViewModel.get(context);
    bloc.user = bloc.getUser()!;
    bloc.fetchSite();
    bloc.fetchUsers();
    bloc.fetchUserSites();
    bloc.doAnimation(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SiteViewModel, SiteState>(
      listener: (context, state) {
        if (state is SiteErrorState) {
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.failed,
            message: state.failure.errorMessage,
            posActionTitle: StringManager.ok,
          );
        }
        if (state is UsersSiteErrorState) {
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.failed,
            message: state.failure.errorMessage,
            posActionTitle: StringManager.ok,
          );
        }
        if (state is AddSiteErrorState) {
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.failed,
            message: state.failure.errorMessage,
            posActionTitle: StringManager.ok,
          );
        }
        if (state is AddSiteSuccessState) {
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.success,
            message: StringManager.siteAddSuccessfully,
            posActionTitle: StringManager.ok,
          );
        }
        if (state is DeleteSiteSuccessState) {
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.success,
            message: StringManager.siteDeleteSuccessfully,
            posActionTitle: StringManager.ok,
          );
        }
        if (state is GetUserSiteErrorState) {
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.failed,
            message: state.failure.errorMessage,
            posActionTitle: StringManager.ok,
          );
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          opacity: 0.4,
          color: ColorManager.greyShade3,
          inAsyncCall: bloc.isLoading,
          progressIndicator: const Center(child: LottieLoadingWidget()),
          child: SafeArea(
              child: Scaffold(
                  appBar: AppBar(
                    title: Text(StringManager.sites,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(fontSize: 25.sp)),
                    actions: [
                      Padding(
                        padding: EdgeInsets.all(15.r),
                        child: Icon(
                          Icons.maps_home_work_rounded,
                          color: ColorManager.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(seconds: 2),
                            opacity: bloc.opacity,
                            curve: Curves.easeIn,
                            child: TextField(
                              controller: bloc.searchController,
                              onChanged: (query) => bloc.filterSites(query),
                              style: const TextStyle(
                                  color: ColorManager.whiteColor),
                              decoration: InputDecoration(
                                hintText: StringManager.searchHint,
                                hintStyle: const TextStyle(
                                    color: ColorManager.whiteColor),
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(26.r),
                                ),
                              ),
                            ),
                          ),
                          state is NoResultSearchSiteSuccessState
                              ? Expanded(
                                  child: Center(
                                    child: Text(
                                      StringManager.noUsersFound,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: ColorManager.greyShade4),
                                    ),
                                  ),
                                )
                              : bloc.user.type == UserAndAdminModelDto.admin
                                  ? Flexible(
                                      child: SlideTransition(
                                        position: bloc.slideAnimation,
                                        child: ListView.builder(
                                            itemCount:
                                                SiteViewModel.get(context)
                                                    .searchedSites
                                                    .length,
                                            itemBuilder: (context, index) {
                                              return SiteInfoItem(
                                                site: bloc.searchedSites[index],
                                                onDelete: () {
                                                  bloc.deleteSite(
                                                      bloc.sites[index]);
                                                  bloc.fetchSite();
                                                },
                                              );
                                            }),
                                      ),
                                    )
                                  : Flexible(
                                      child: ListView.builder(
                                          itemCount: SiteViewModel.get(context)
                                              .userSites
                                              .length,
                                          itemBuilder: (context, index) {
                                            return SiteInfoItem(
                                              site: bloc.userSites[index],
                                              onDelete: () {},
                                            );
                                          }),
                                    ),
                        ]),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat,
                  floatingActionButton:
                      bloc.user.type == UserAndAdminModelDto.admin
                          ? AnimatedOpacity(
                              duration: const Duration(seconds: 2),
                              opacity: bloc.opacity,
                              curve: Curves.easeIn,
                              child: FloatingActionButton(
                                backgroundColor: ColorManager.primaryColor,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return const AddNewSite();
                                      });
                                },
                                child: const Icon(
                                  Icons.add,
                                  color: ColorManager.whiteColor,
                                ),
                              ),
                            )
                          : null)),
        );
      },
    );
  }
}

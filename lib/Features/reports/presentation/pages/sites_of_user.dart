import 'package:bug_away/Core/component/empty_pages.dart';
import 'package:bug_away/Core/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bug_away/Config/routes/routes_manger.dart';
import 'package:bug_away/Core/component/search_field_widget.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/reports/presentation/widgets/site_widget.dart';
import 'package:bug_away/di/di.dart';

import '../../../../Core/component/lottie_loading_widget.dart';
import '../../../../Core/utils/colors.dart';
import '../manager/get_sites_of_user_view_model.dart';
import '../manager/get_sites_states.dart';

class SitesOFUser extends StatefulWidget {
  const SitesOFUser({super.key});

  @override
  State<SitesOFUser> createState() => _SitesOFUserState();
}

class _SitesOFUserState extends State<SitesOFUser>
    with SingleTickerProviderStateMixin {
  GetSitesOfUsersViewModel viewModel = getIt<GetSitesOfUsersViewModel>();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel.initializeAnimation(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      var args = ModalRoute.of(context)!.settings.arguments as String;
      viewModel.getSites(args);
    });

    searchController.addListener(() {
      viewModel.searchSites(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      opacity: 0.4,
      color: ColorManager.greyShade3,
      inAsyncCall: viewModel.isLoading,
      progressIndicator: const Center(child: LottieLoadingWidget()),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: const Text(StringManager.sites),
        ),
        body: BlocBuilder<GetSitesOfUsersViewModel, GetSitesState>(
          bloc: viewModel,
          builder: (context, state) {
            return Column(
              children: [
                AnimatedOpacity(
                  duration: const Duration(seconds: 2),
                  opacity: viewModel.opacity,
                  curve: Curves.easeIn,
                  child: SearchFieldWidget(
                    controller: searchController,
                    onChanged: (value) => viewModel.searchSites(value),
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state is GetSitesErrorState) {
                        return const Center(
                          child: EmptyStateWidget(
                            lottiePath: ImageManager.emptySearchLottie,
                            message: StringManager.noSitesFound,
                          ),
                        );
                      } else if (state is NoSearchResultsState) {
                        return const Center(
                          child: EmptyStateWidget(
                            lottiePath: ImageManager.emptySearchLottie,
                            message: StringManager.noSitesFound,
                          ),
                        );
                      } else {
                        return SlideTransition(
                          position: viewModel.slideAnimation,
                          child: Padding(
                            padding: EdgeInsets.all(4.sp),
                            child: ListView.builder(
                              itemCount: viewModel.allSites.length,
                              itemBuilder: (context, index) {
                                final site = viewModel.allSites[index];

                                return SiteWidget(
                                  siteName: site.siteName ?? '',
                                  siteLocation: site.siteLocation ?? '',
                                  onClicked: () {
                                    Navigator.pushNamed(
                                      context,
                                      RoutesManger.routeNameReportOfSiteScreen,
                                      arguments: site.siteId,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

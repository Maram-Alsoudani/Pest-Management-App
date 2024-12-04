import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bug_away/Config/routes/routes_manger.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/reports/presentation/widgets/site_widget.dart';
import 'package:bug_away/di/di.dart';

import '../../../../Core/component/lottie_loading_widget.dart';
import '../../../../Core/component/text_feild_custom.dart';
import '../../../../Core/utils/colors.dart';
import '../manager/get_sites_of_user_view_model.dart';
import '../manager/get_sites_states.dart';

class SitesOFUser extends StatefulWidget {
  SitesOFUser({super.key});

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
          title: Text(StringManager.sites),
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
                      if (state is GetSitesErrorState) {
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
                          position: viewModel.slideAnimation,
                          child: Padding(
                            padding: EdgeInsets.all(15.sp),
                            child: ListView.builder(
                              itemCount: viewModel.allSites.length,
                              itemBuilder: (context, index) {
                                final site = viewModel.allSites[index];

                                return InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context,
                                        RoutesManger
                                            .routeNameReportOfSiteScreen,
                                        arguments: site.siteId);
                                  },
                                  child: SiteWidget(
                                    siteName: site.siteName ?? "",
                                    siteLocation: site.siteLocation ?? "",
                                  ),
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

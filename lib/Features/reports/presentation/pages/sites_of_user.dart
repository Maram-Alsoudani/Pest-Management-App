import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pesticides/Features/reports/presentation/manager/get_sites_of_user_view_model.dart';
import 'package:pesticides/Features/reports/presentation/widgets/site_widget.dart';
import 'package:pesticides/di/di.dart';

import '../../../../Core/component/lottie_loading_widget.dart';
import '../../../../Core/utils/colors.dart';
import '../manager/get_sites_states.dart';

class SitesOFUser extends StatefulWidget {
  SitesOFUser({super.key});

  @override
  State<SitesOFUser> createState() => _SitesOFUserState();
}

class _SitesOFUserState extends State<SitesOFUser>
    with SingleTickerProviderStateMixin {
  GetSitesOfUsersViewModel viewModel = getIt<GetSitesOfUsersViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.initializeAnimation(this);
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as String;
    return ModalProgressHUD(
      opacity: 0.4,
      color: ColorManager.greyShade3,
      inAsyncCall: viewModel.isLoading,
      progressIndicator: const Center(child: LottieLoadingWidget()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Reports"),
        ),
        body: BlocBuilder<GetSitesOfUsersViewModel, GetSitesState>(
          bloc: viewModel..getSites(args),
          builder: (context, state) {
            if (state is GetSitesErrorState) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else if (state is GetSitesSuccessState) {
              return Column(
                children: [
                  Expanded(
                    child: SlideTransition(
                      position: viewModel.slideAnimation,
                      child: Padding(
                        padding: EdgeInsets.all(15.sp),
                        child: ListView.builder(
                          itemCount: state.sitesList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                                onTap: () {
                                  //TODO : Navigation
                                },
                                child: SiteWidget(
                                    siteName:
                                        state.sitesList[index].siteName ?? "",
                                    siteLocation:
                                        state.sitesList[index].siteLocation ??
                                            ""));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

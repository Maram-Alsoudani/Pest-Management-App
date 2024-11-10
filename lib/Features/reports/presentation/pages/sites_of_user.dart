import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Features/reports/presentation/manager/get_sites_of_user_view_model.dart';
import 'package:pesticides/Features/reports/presentation/widgets/site_widget.dart';
import 'package:pesticides/di/di.dart';

import '../../../../Core/utils/colors.dart';
import '../manager/get_sites_states.dart';

class SitesOFUser extends StatefulWidget {
  SitesOFUser({super.key});

  @override
  State<SitesOFUser> createState() => _SitesOFUserState();
}

class _SitesOFUserState extends State<SitesOFUser> {
  GetSitesOfUsersViewModel viewModel = getIt<GetSitesOfUsersViewModel>();

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
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
                                siteName: state.sitesList[index].siteName ?? "",
                                siteLocation:
                                    state.sitesList[index].siteLocation ?? ""));
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return Center(
              child:
                  CircularProgressIndicator(color: ColorManager.primaryColor));
        },
      ),
    );
  }
}

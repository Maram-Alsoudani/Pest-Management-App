import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pesticides/Config/routes/routes_manger.dart';
import 'package:pesticides/Core/utils/images.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Features/site/presentation/manager/site_state.dart';
import 'package:pesticides/Features/site/presentation/manager/site_view_model.dart';
import 'package:pesticides/Features/site/presentation/widgets/add_new_site.dart';
import '../../../../Core/component/custom_dialog.dart';
import '../../../../Core/component/lottie_loading_widget.dart';
import '../widgets/expansion_tile_custom.dart';
import '../../../../Core/utils/strings.dart';
import '../widgets/list_tile_custom.dart';
import '../widgets/site_info_item.dart';

class SitesScreen extends StatefulWidget {
  SitesScreen({super.key});

  @override
  State<SitesScreen> createState() => _SitesScreenState();
}

class _SitesScreenState extends State<SitesScreen> {
  late SiteViewModel bloc;
  @override
  void initState() {
    bloc = SiteViewModel.get(context);
    bloc.fetchSite();
    bloc.fetchUsers();
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
            body: Container(
              width: 500.w,
              margin: EdgeInsets.all(15.r),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                  color: ColorManager.whiteColor,
                  borderRadius: BorderRadius.circular(15.r),
                  image: const DecorationImage(
                      opacity: 0.5,
                      image: AssetImage(
                        ImageManager.location,
                      ))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: ListView.builder(
                          itemCount: SiteViewModel.get(context).sites.length,
                          itemBuilder: (context, index) {
                            return SiteInfoItem(
                              site: bloc.sites[index],
                            );
                          }),
                    ),
                  ]),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: FloatingActionButton(
              backgroundColor: ColorManager.primaryColor,
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AddNewSite();
                    });
              },
              child: const Icon(
                Icons.add,
                color: ColorManager.whiteColor,
              ),
            ),
          )),
        );
      },
    );
  }
}

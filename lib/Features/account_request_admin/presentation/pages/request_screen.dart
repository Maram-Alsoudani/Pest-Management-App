import 'package:bug_away/Core/component/empty_pages.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bug_away/Core/component/custom_dialog.dart';
import 'package:bug_away/Core/component/lottie_loading_widget.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/images.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/account_request_admin/presentation/manager/requests_screen_viewmodel_cubit.dart';
import 'package:bug_away/Features/account_request_admin/presentation/widgets/button_icon.dart';
import 'package:bug_away/Features/account_request_admin/presentation/widgets/label_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bug_away/Features/user_request_account/domain/entities/user_request_account_model_entity.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = RequestsScreenViewmodelCubit.get(context);
    viewModel.getRequest();
    return BlocConsumer<RequestsScreenViewmodelCubit,
        RequestsScreenViewmodelState>(listener: (context, state) {
      if (state is RequestsScreenViewmodelError) {
        DialogUtils.showAlertDialog(
          context: context,
          title: StringManager.failed,
          message: state.error.errorMessage,
          posActionTitle: StringManager.ok,
        );
      } else if (state is AcceptRequestsScreenViewmodelError) {
        DialogUtils.showAlertDialog(
          context: context,
          title: StringManager.failed,
          message: state.error.errorMessage,
          posActionTitle: StringManager.ok,
        );
      } else if (state is AcceptRequestsScreenViewmodelSuccess) {
        DialogUtils.showAlertDialog(
          context: context,
          title: StringManager.success,
          message: StringManager.acceptedSuccessfully,
          posActionTitle: StringManager.ok,
        );
      } else if (state is DeclineRequestsScreenViewmodelSuccess) {
        DialogUtils.showAlertDialog(
          context: context,
          title: StringManager.success,
          message: StringManager.declinedSuccessfully,
          posActionTitle: StringManager.ok,
        );
      } else if (state is DeleteRequestsScreenViewmodelSuccess) {
        DialogUtils.showAlertDialog(
          context: context,
          title: StringManager.success,
          message: StringManager.deleteSuccess,
          posActionTitle: StringManager.ok,
        );
      }
    }, builder: (context, state) {
      return ModalProgressHUD(
        opacity: 0.4,
        color: ColorManager.greyShade3,
        inAsyncCall: viewModel.isLoading,
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
                appBar: AppBar(
                  elevation: 0,
                  surfaceTintColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  title: Text(
                    StringManager.accountRequests,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 20.sp),
                  ),
                ),
                backgroundColor: Colors.transparent,
                body: viewModel.requests.isEmpty
                    ? const Center(
                        child: EmptyStateWidget(
                            lottiePath: ImageManager.emptyRequestLottie,
                            message: StringManager.noRequestFound))
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: viewModel.scrollController,
                              itemCount: viewModel.requests.length,
                              itemBuilder: (context, index) {
                                final request = viewModel.requests[index];

                                return Padding(
                                  padding: EdgeInsets.all(12.r),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(22.r),
                                    child: Slidable(
                                      dragStartBehavior: DragStartBehavior.down,
                                      endActionPane: ActionPane(
                                        dragDismissible: false,
                                        motion: const BehindMotion(),
                                        extentRatio: 0.22,
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              viewModel.deleteRequest(
                                                  request.id ?? "");
                                            },
                                            backgroundColor:
                                                ColorManager.primaryColor,
                                            foregroundColor:
                                                ColorManager.whiteColor,
                                            icon: FontAwesomeIcons.trash,
                                            label: StringManager.delete,
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(16.r),
                                        decoration: const BoxDecoration(
                                          color: ColorManager.backgroundColor,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                request.image!.isNotEmpty
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    100.r),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl:
                                                              request.image ??
                                                                  "",
                                                          placeholder: (context,
                                                                  url) =>
                                                              const CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                                  ImageManager
                                                                      .avatar),
                                                          width: 110.w,
                                                          height: 110.h,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      )
                                                    : Image.asset(
                                                        ImageManager.avatar,
                                                        width: 110.w,
                                                        height: 110.h,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ],
                                            ),
                                            LabelText(
                                                label:
                                                    "${StringManager.name}: ${request.userName} "),
                                            LabelText(
                                                label:
                                                    "${StringManager.email}: ${request.email}"),
                                            LabelText(
                                                label:
                                                    "${StringManager.phone}: ${request.phone}"),
                                            LabelText(
                                                label:
                                                    "${StringManager.role}: ${request.type}"),
                                            if (request.status == "Accepted" ||
                                                request.status == "Rejected")
                                              const SizedBox()
                                            else
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  ButtonAndIcon(
                                                    color: ColorManager
                                                        .primaryColor,
                                                    title:
                                                        StringManager.decline,
                                                    onTap: () {
                                                      UserRequestAccountEntity
                                                          user =
                                                          UserRequestAccountEntity(
                                                        id: request.id,
                                                        status: request.status,
                                                        image: request.image,
                                                        type: request.type,
                                                        userName:
                                                            request.userName,
                                                        phone: request.phone,
                                                        email: request.email,
                                                        password:
                                                            request.password,
                                                        dateTime:
                                                            request.dateTime,
                                                      );
                                                      viewModel
                                                          .declineRequest(user);
                                                    },
                                                    icon: FontAwesomeIcons
                                                        .userXmark,
                                                  ),
                                                  SizedBox(width: 20.w),
                                                  ButtonAndIcon(
                                                    color: ColorManager
                                                        .dialogGreenColor,
                                                    title: StringManager.accept,
                                                    onTap: () {
                                                      UserRequestAccountEntity
                                                          user =
                                                          UserRequestAccountEntity(
                                                        id: request.id,
                                                        status: request.status,
                                                        image: request.image,
                                                        type: request.type,
                                                        userName:
                                                            request.userName,
                                                        phone: request.phone,
                                                        email: request.email,
                                                        password:
                                                            request.password,
                                                        dateTime:
                                                            request.dateTime,
                                                      );
                                                      viewModel
                                                          .acceptRequest(user);
                                                    },
                                                    icon: FontAwesomeIcons
                                                        .userCheck,
                                                  ),
                                                ],
                                              ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                if (request.status == null)
                                                  LabelText(
                                                    label: StringManager
                                                        .waitingForOperation,
                                                    fontSize: 12.sp,
                                                    color: ColorManager
                                                        .yellowColor,
                                                  )
                                                else if (request.status ==
                                                    "Accepted")
                                                  Row(
                                                    children: [
                                                      LabelText(
                                                        label: StringManager
                                                            .acceptedAccountRequest,
                                                        fontSize: 12.sp,
                                                        color: ColorManager
                                                            .dialogGreenColor,
                                                      ),
                                                    ],
                                                  )
                                                else if (request.status ==
                                                    "Rejected")
                                                  LabelText(
                                                    label: StringManager
                                                        .rejectedAccountRequest,
                                                    fontSize: 12.sp,
                                                    color:
                                                        ColorManager.redColor,
                                                  ),
                                                LabelText(
                                                  label:
                                                      viewModel.formatDateTime(
                                                          request.dateTime),
                                                  fontSize: 12.sp,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

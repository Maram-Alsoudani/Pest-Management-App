import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bug_away/Core/component/custom_dialog.dart';
import 'package:bug_away/Core/component/lottie_loading_widget.dart';
import 'package:bug_away/Core/component/text_feild_custom.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/inventory/presentation/manager/inventory_view_model_cubit.dart';
import 'package:bug_away/Features/inventory/presentation/widgets/dialog_added_materail.dart';
import 'package:bug_away/Features/inventory/presentation/widgets/materail_item.dart';
import 'package:bug_away/Features/register/data/models/user_model_dto.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late InventoryViewModelCubit bloc;

  @override
  void initState() {
    super.initState();
    bloc = InventoryViewModelCubit.get(context);
    bloc.getMaterails();
    bloc.doAnimation(this);
    bloc.searchController.addListener(bloc.searchMethod);
    bloc.user = bloc.getUser()!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InventoryViewModelCubit, InventoryViewModelState>(
      listener: (context, state) {
        if (state is InventoryAddedMaterailSuccess) {
          // Safe to show dialog
          if (mounted) {
            DialogUtils.showAlertDialog(
              context: context,
              title: StringManager.success,
              message: StringManager.addedSuccessfully,
              posActionTitle: StringManager.ok,
            );
          }
        } else if (state is InventoryAddedMaterailError) {
          if (mounted) {
            DialogUtils.showAlertDialog(
              context: context,
              title: StringManager.failed,
              message: state.error.errorMessage,
              posActionTitle: StringManager.ok,
            );
          }
        } else if (state is InventoryGetMaterailError) {
          if (mounted) {
            DialogUtils.showAlertDialog(
              context: context,
              title: StringManager.failed,
              message: state.error.errorMessage,
              posActionTitle: StringManager.ok,
            );
          }
        } else if (state is InventoryUpdateMaterailError) {
          if (mounted) {
            DialogUtils.showAlertDialog(
              context: context,
              title: StringManager.failed,
              message: state.error.errorMessage,
              posActionTitle: StringManager.ok,
            );
          }
        } else if (state is InventoryUpdateMaterailSuccess) {
          if (mounted) {
            DialogUtils.showAlertDialog(
              context: context,
              title: StringManager.success,
              message: StringManager.updateSuccessfully,
              posActionTitle: StringManager.ok,
            );
          }
        } else if (state is InventoryDeleteMaterailSuccess) {
          if (mounted) {
            DialogUtils.showAlertDialog(
              context: context,
              title: StringManager.success,
              message: StringManager.deletedSuccessfully,
              posActionTitle: StringManager.ok,
            );
          }
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          opacity: 0.4,
          color: ColorManager.greyShade3,
          inAsyncCall: bloc.isLoading,
          progressIndicator: const Center(child: LottieLoadingWidget()),
          child: Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              title: Text(
                StringManager.inventory,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(fontSize: 25.sp),
              ),
            ),
            floatingActionButton: bloc.user.type == UserAndAdminModelDto.admin
                ? AnimatedOpacity(
                    duration: const Duration(seconds: 2),
                    opacity: bloc.opacity,
                    curve: Curves.easeIn,
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      backgroundColor: ColorManager.primaryColor,
                      onPressed: () {
                        InventoryViewModelCubit.get(context)
                            .nameController
                            .clear();
                        InventoryViewModelCubit.get(context)
                            .quantityController
                            .clear();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AddedOrEditMaterailDialog(
                              buttonName: StringManager.save,
                              title: StringManager.addMaterial,
                              onTap: () {
                                InventoryViewModelCubit.get(context)
                                    .addedMaterails();
                                Navigator.pop(context);
                                bloc.getMaterails();
                              },
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.add,
                        color: ColorManager.whiteColor,
                      ),
                    ),
                  )
                : null,
            body: Padding(
              padding: EdgeInsets.all(10.0.r),
              child: Column(
                children: [
                  AnimatedOpacity(
                    duration: const Duration(seconds: 2),
                    opacity: bloc.opacity,
                    curve: Curves.easeIn,
                    child: CustomTextFormField(
                      hint: StringManager.searchHint,
                      controller: bloc.searchController,
                      validator: (value) {
                        return null;
                      },
                      borderRadius: BorderRadius.circular(28.0.r),
                    ),
                  ),
                  SizedBox(height: 6.0.h),
                  state is InventoryNoSearchResultMaterail
                      ? Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                StringManager.noResultsFound,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(fontSize: 20.sp),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: SlideTransition(
                            position: bloc.slideAnimation,
                            child: ListView.builder(
                              itemCount: bloc.filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = bloc.filteredItems[index];
                                final isUnavailable = (item.quantity is int &&
                                        item.quantity == 0) ||
                                    (item.quantity is String &&
                                        int.parse(item.quantity as String) ==
                                            0);
                                return MaterailItem(
                                  isUnavailable: isUnavailable,
                                  item: item,
                                  onEdit: () {
                                    bloc.nameController.text = item.name ?? "";
                                    bloc.quantityController.text =
                                        item.quantity.toString();
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AddedOrEditMaterailDialog(
                                          title: StringManager.edit,
                                          buttonName: StringManager.save,
                                          onTap: () {
                                            InventoryViewModelCubit.get(context)
                                                .updateMaterails(item.id);
                                            InventoryViewModelCubit.get(context)
                                                .nameController
                                                .clear();
                                            InventoryViewModelCubit.get(context)
                                                .quantityController
                                                .clear();
                                            Navigator.pop(context);
                                            bloc.getMaterails();
                                          },
                                        );
                                      },
                                    );
                                  },
                                  onDelete: () {
                                    bloc.deleteMaterails(item.id, index);
                                  },
                                );
                              },
                            ),
                          ),
                        )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

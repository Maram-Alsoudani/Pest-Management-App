import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pesticides/Core/component/custom_dialog.dart';
import 'package:pesticides/Core/component/lottie_loading_widget.dart';
import 'package:pesticides/Core/component/text_feild_custom.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/inventory/presentation/manager/inventory_view_model_cubit.dart';
import 'package:pesticides/Features/inventory/presentation/widgets/dialog_added_materail.dart';
import 'package:pesticides/Features/inventory/presentation/widgets/materail_item.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  late InventoryViewModelCubit bloc;

  @override
  void initState() {
    super.initState();
    bloc = InventoryViewModelCubit.get(context);
    bloc.getMaterails();
    bloc.searchController.addListener(bloc.searchMethod);
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
              message: "Added Successfully",
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
              message: "Updated Successfully",
              posActionTitle: StringManager.ok,
            );
          }
        }else if (state is InventoryDeleteMaterailSuccess) {
          if (mounted) {
            DialogUtils.showAlertDialog(
              context: context,
              title: StringManager.success,
              message: "Deleted Successfully",
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
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AddedOrEditMaterailDialog(
                          title: StringManager.addMaterial,
                          buttonName: "Add",
                          onTap: () {
                            InventoryViewModelCubit.get(context).addedMaterails();
                            InventoryViewModelCubit.get(context).nameController.clear();
                            InventoryViewModelCubit.get(context).quantityController.clear();
                            Navigator.pop(context);
                            bloc.getMaterails();
                          },
                        );
                      },
                    );
                  },
                  icon: Icon(
                    Icons.add,
                    color: ColorManager.primaryColor,
                    size: 28.sp,
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsets.all(10.0.r),
              child: Column(
                children: [
                  CustomTextFormField(
                    hint: StringManager.searchHint,
                    controller: bloc.searchController,
                    validator: (value) {
                      return null;
                    },
                    borderRadius: BorderRadius.circular(26.0.r),
                  ),
                  SizedBox(height: 6.0.h),
                  Expanded(
                    child: ListView.builder(
                      itemCount: bloc.filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = bloc.filteredItems[index];
                        final isUnavailable =
                            (item.quantity is int && item.quantity == 0) ||
                                (item.quantity is String &&
                                    int.parse(item.quantity as String) == 0);
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0.r),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0.r),
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorManager.whiteColor,
                                borderRadius: BorderRadius.circular(16.0.r),
                              ),
                              child: Slidable(
                                dragStartBehavior: DragStartBehavior.down,
                                endActionPane: ActionPane(
                                  dragDismissible: false,
                                  motion: const BehindMotion(),
                                  extentRatio: 0.25,
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        bloc.deleteMaterails(item.id);
                                        bloc.getMaterails();


                                      },
                                      backgroundColor:
                                      ColorManager.primaryColor,
                                      foregroundColor: ColorManager.whiteColor,
                                      icon: Icons.delete,
                                      label: StringManager.delete,
                                    ),
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: () {
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
                                            InventoryViewModelCubit.get(context).updateMaterails(item.id);
                                            InventoryViewModelCubit.get(context).nameController.clear();
                                            InventoryViewModelCubit.get(context).quantityController.clear();
                                            Navigator.pop(context);
                                            bloc.getMaterails();
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: MaterailItem(
                                    isUnavailable: isUnavailable,
                                    item: item,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
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

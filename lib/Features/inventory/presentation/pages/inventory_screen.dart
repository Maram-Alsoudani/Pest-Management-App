import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bug_away/Core/component/custom_dialog.dart';
import 'package:bug_away/Core/component/lottie_loading_widget.dart';
import 'package:bug_away/Core/component/search_field_widget.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/inventory/presentation/manager/inventory_view_model_cubit.dart';
import 'package:bug_away/Features/inventory/presentation/widgets/dialog_added_materail.dart';
import 'package:bug_away/Features/inventory/presentation/widgets/materail_item.dart';
import 'package:bug_away/Features/register/data/models/user_model_dto.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

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
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.success,
            message: StringManager.addMaterial,
            posActionTitle: StringManager.ok,
          );
        } else if (state is InventoryAddedMaterailError) {
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.error,
            message: state.error.errorMessage,
            posActionTitle: StringManager.ok,
          );
        } else if (state is InventoryGetMaterailError) {
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.error,
            message: state.error.errorMessage,
            posActionTitle: StringManager.ok,
          );
        } else if (state is InventoryUpdateMaterailError) {
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.error,
            message: state.error.errorMessage,
            posActionTitle: StringManager.ok,
          );
        } else if (state is InventoryUpdateMaterailSuccess) {
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.success,
            message: StringManager.materialUpdated,
            posActionTitle: StringManager.ok,
          );
        } else if (state is InventoryDeleteMaterailSuccess) {
          DialogUtils.showAlertDialog(
            context: context,
            title: StringManager.success,
            message: StringManager.materialDeleted,
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
          child: Scaffold(
            appBar: AppBar(
              title: const Text(StringManager.inventory),
              actions: [
                if (bloc.user.type == 'admin')
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AddedOrEditMaterailDialog(
                            buttonName: StringManager.add,
                            title: StringManager.addMaterial,
                            onTap: () {
                              if (bloc.formKey.currentState!.validate()) {
                                bloc.addedMaterails();
                                Navigator.pop(context);
                              }
                            },
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SearchFieldWidget(
                    controller: bloc.searchController,
                    onChanged: (value) => bloc.searchMethod(),
                  ),
                  Expanded(
                    child: bloc.filteredItems.isEmpty
                        ? Center(
                            child: Text(
                              StringManager.noMaterialsFound,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(color: ColorManager.whiteColor),
                            ),
                          )
                        : ListView.builder(
                            itemCount: bloc.filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = bloc.filteredItems[index];
                              return MaterailItem(
                                isUnavailable: item.quantity == 0,
                                item: item,
                                onEdit: bloc.user.type == 'admin'
                                    ? () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AddedOrEditMaterailDialog(
                                              buttonName: StringManager.update,
                                              title: StringManager.editMaterial,
                                              onTap: () {
                                                if (bloc.formKey.currentState!
                                                    .validate()) {
                                                  bloc.updateMaterails(item.id);
                                                  Navigator.pop(context);
                                                }
                                              },
                                            );
                                          },
                                        );
                                      }
                                    : null,
                                onDelete: bloc.user.type == 'admin'
                                    ? () {
                                        DialogUtils.showAlertDialog(
                                          context: context,
                                          title: StringManager.delete,
                                          message: StringManager
                                              .deleteMaterialMessage,
                                          posActionTitle: StringManager.ok,
                                          negActionTitle: StringManager.cancel,
                                          posAction: () {
                                            bloc.deleteMaterails(
                                                item.id, index);
                                          },
                                        );
                                      }
                                    : null,
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

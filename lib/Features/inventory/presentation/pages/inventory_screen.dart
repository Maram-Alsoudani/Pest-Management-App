import 'package:bug_away/Core/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:bug_away/Core/component/custom_dialog.dart';
import 'package:bug_away/Core/component/lottie_loading_widget.dart';
import 'package:bug_away/Core/component/search_field_widget.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/inventory/presentation/manager/inventory_view_model_cubit.dart';
import 'package:bug_away/Features/inventory/presentation/widgets/dialog_added_materail.dart';
import 'package:bug_away/Features/inventory/presentation/widgets/materail_item.dart';
import '../../../../Core/component/empty_pages.dart';

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
            message: StringManager.materialAdded,
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
          color: ColorManager.overlayColor,
          inAsyncCall: bloc.isInitialLoad,
          progressIndicator: const Center(child: LottieLoadingWidget()),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              title: const Text(StringManager.inventory),
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
                    child: Stack(
                      children: [
                        bloc.filteredItems.isEmpty && !bloc.isLoading
                            ? const EmptyStateWidget(
                                lottiePath: ImageManager.emptyBoxLottie,
                                message: StringManager.noMaterialsFound,
                              )
                            : ListView.builder(
                                itemCount: bloc.filteredItems.length,
                                itemBuilder: (context, index) {
                                  final item = bloc.filteredItems[index];
                                  return MaterailItem(
                                    isUnavailable: item.quantity == 0,
                                    item: item,
                                    isAdmin: bloc.user.type == 'admin',
                                    onEdit: bloc.user.type == 'admin'
                                        ? () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AddedOrEditMaterailDialog(
                                                  buttonName:
                                                      StringManager.update,
                                                  title: StringManager
                                                      .editMaterial,
                                                  onTap: () {
                                                    bloc.updateMaterails(
                                                        item.id);
                                                    Navigator.pop(context);
                                                  },
                                                  materail: item,
                                                );
                                              },
                                            );
                                          }
                                        : null,
                                    onDelete: bloc.user.type == 'admin'
                                        ? () {
                                            bloc.deleteMaterails(
                                                item.id, index);
                                          }
                                        : null,
                                    onIncrement: () =>
                                        bloc.incrementQuantity(item),
                                    onDecrement: () =>
                                        bloc.decrementQuantity(item),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: bloc.user.type == 'admin'
                ? FloatingActionButton(
                    backgroundColor: ColorManager.primaryColor,
                    shape: const CircleBorder(),
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
                    child: const Icon(
                      Icons.add,
                      color: ColorManager.whiteColor,
                    ),
                  )
                : null,
          ),
        );
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:bug_away/Core/component/button_custom.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Features/site_report/presentation/manager/report_view_model.dart';
import '../../../../../Core/component/custom_dialog.dart';
import 'search_material_screen.dart';

class MaterialUsageScreen extends StatefulWidget {
  const MaterialUsageScreen({super.key});

  @override
  _MaterialUsageScreenState createState() => _MaterialUsageScreenState();
}

class _MaterialUsageScreenState extends State<MaterialUsageScreen>
    with SingleTickerProviderStateMixin {
  Map<String, int> materials = {};
  Map<String, int> availableQuantities = {};
  final double _opacity = 0.0;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  void addItem(String item, int quantity, int availableQuantity) {
    setState(() {
      materials[item] = quantity;
      availableQuantities[item] = availableQuantity;
    });
  }

  void removeItem(String item) {
    setState(() {
      materials.remove(item);
      availableQuantities.remove(item);
    });
  }

  void updateQuantity(String materialName, int change) {
    setState(() {
      final currentQuantity = materials[materialName] ?? 0;
      final newQuantity = currentQuantity + change;
      if (newQuantity > 0) {
        materials[materialName] = newQuantity;
      } else {
        showDeleteConfirmationDialog(materialName);
      }
    });
  }

  void showDeleteConfirmationDialog(String materialName) {
    DialogUtils.showAlertDialog(
      context: context,
      title: 'Confirm Delete',
      message: 'Are you sure you want to delete this item?',
      posActionTitle: 'Delete',
      negActionTitle: 'Cancel',
      posAction: () {
        removeItem(materialName);
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _slideAnimation =
        Tween<Offset>(begin: Offset(-1.w, 0), end: const Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });

    // Initialize materials based on the saved state
    final reportViewModel = context.read<ReportViewModel>();
    materials = Map.from(reportViewModel.materials);
    // Initialize available quantities based on the saved state
    // Assuming available quantities are also stored in the reportViewModel
    // If not, you need to fetch them from the appropriate source
    // availableQuantities = Map.from(reportViewModel.availableQuantities);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportViewModel = context.read<ReportViewModel>();

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          StringManager.materialUsages,
          style:
              Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 25.sp),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: ColorManager.whiteColor),
            onPressed: () {
              reportViewModel.updateMaterials(materials);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          children: [
            Expanded(
              child: SlideTransition(
                position: _slideAnimation,
                child: ListView.builder(
                  itemCount: materials.length,
                  itemBuilder: (context, index) {
                    final material = materials.keys.elementAt(index);
                    final quantity = materials[material]!;
                    final availableQuantity =
                        availableQuantities[material] ?? 0;
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
                            key: ValueKey(material),
                            endActionPane: ActionPane(
                              dragDismissible: false,
                              motion: const BehindMotion(),
                              extentRatio: 0.20,
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    showDeleteConfirmationDialog(material);
                                  },
                                  backgroundColor: ColorManager.primaryColor,
                                  foregroundColor: ColorManager.whiteColor,
                                  icon: Icons.delete,
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.inventory,
                                  color: ColorManager.primaryColor),
                              title: Text(
                                material,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: ColorManager.primaryColor),
                              ),
                              subtitle: Text(
                                'Quantity: $quantity',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: Colors.grey),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Visibility(
                                    visible: quantity > 0,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: IconButton(
                                      icon: const Icon(Icons.remove_circle,
                                          color: ColorManager.primaryColor),
                                      onPressed: () {
                                        updateQuantity(material, -1);
                                      },
                                    ),
                                  ),
                                  Text(
                                    '$quantity',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: ColorManager.blackColor),
                                  ),
                                  Visibility(
                                    visible: quantity < availableQuantity,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    child: IconButton(
                                      icon: const Icon(Icons.add_circle,
                                          color: ColorManager.primaryColor),
                                      onPressed: () {
                                        updateQuantity(material, 1);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16.0.h),
            Center(
              child: SlideTransition(
                position: _slideAnimation,
                child: SizedBox(
                  width: 200.w,
                  child: ButtonCustom(
                    buttonName: StringManager.addMaterial,
                    textStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchMaterialUsageScreen(),
                        ),
                      );
                      if (result != null) {
                        final data = result as Map<String, Map<String, int>>;
                        final newMaterials = data['selectedQuantities']!;
                        final newAvailableQuantities =
                            data['availableQuantities']!;
                        newMaterials.forEach((key, value) {
                          addItem(key, value, newAvailableQuantities[key]!);
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0.h),
          ],
        ),
      ),
    );
  }
}

import 'package:bug_away/Features/inventory/data/models/materail_model_dto.dart';
import 'package:bug_away/Features/material_usage/presentation/widgets/usage_material_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/component/button_custom.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Features/site_report/presentation/manager/report_view_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  Map<String, String> materialUnits = {}; // Add this map to store units
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  void addItem(String item, int quantity, int availableQuantity, String unit) {
    setState(() {
      materials[item] = quantity;
      availableQuantities[item] = availableQuantity;
      materialUnits[item] = unit; // Store unit
    });
  }

  void removeItem(String item) {
    setState(() {
      materials.remove(item);
      availableQuantities.remove(item);
      materialUnits.remove(item); // Remove unit
    });
  }

  void updateQuantity(String materialName, int change) {
    setState(() {
      final currentQuantity = materials[materialName] ?? 0;
      final newQuantity = currentQuantity + change;
      if (newQuantity >= 0 &&
          newQuantity <= availableQuantities[materialName]!) {
        materials[materialName] = newQuantity;
      } else if (newQuantity <= 0) {
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
    availableQuantities = Map.from(reportViewModel.availableQuantities);
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
            icon: const FaIcon(FontAwesomeIcons.solidFloppyDisk,
                color: ColorManager.whiteColor),
            onPressed: () {
              reportViewModel.updateMaterials(materials);
              reportViewModel.updateAvailableQuantities(availableQuantities);
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
                    final unit = materialUnits[material] ?? 'Unit'; // Get unit
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.r),
                      child: MaterialUsageItem(
                        isUnavailable: availableQuantity == 0,
                        item: MaterailModelDto(
                          name: material,
                          quantity: quantity,
                          unit: unit, // Use unit
                        ),
                        availableQuantity: availableQuantity,
                        selectedQuantity: quantity,
                        unit: unit, // Pass unit
                        onIncrement: () => updateQuantity(material, 1),
                        onDecrement: () => updateQuantity(material, -1),
                        onDelete: () => showDeleteConfirmationDialog(material),
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
                          builder: (context) =>
                              const SearchMaterialUsageScreen(),
                        ),
                      );
                      if (result != null) {
                        final data = result as Map<String, dynamic>;
                        final newMaterials =
                            data['selectedQuantities'] as Map<String, int>;
                        final newAvailableQuantities =
                            data['availableQuantities'] as Map<String, int>;
                        final newMaterialUnits =
                            data['materialUnits'] as Map<String, String>;
                        newMaterials.forEach((key, value) {
                          addItem(key, value, newAvailableQuantities[key]!,
                              newMaterialUnits[key]!);
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

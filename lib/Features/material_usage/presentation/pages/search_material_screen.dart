import 'package:bug_away/Features/material_usage/presentation/widgets/search_material_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Core/utils/firebase_utils.dart';
import 'package:bug_away/Features/inventory/data/models/materail_model_dto.dart';
import 'package:bug_away/Core/component/search_field_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchMaterialUsageScreen extends StatefulWidget {
  const SearchMaterialUsageScreen({super.key});

  @override
  SearchMaterialScreenState createState() => SearchMaterialScreenState();
}

class SearchMaterialScreenState extends State<SearchMaterialUsageScreen>
    with SingleTickerProviderStateMixin {
  List<MaterailModelDto> materials = [];
  List<MaterailModelDto> filteredMaterials = [];
  Map<String, int> selectedQuantities = {};
  Map<String, int> availableQuantities = {};
  Map<String, String> materialUnits = {};
  TextEditingController searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    fetchMaterials();
    searchController.addListener(filterList);
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _slideAnimation =
        Tween<Offset>(begin: Offset(-1.w, 0), end: const Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {});
      _animationController.forward();
    });
  }

  Future<void> fetchMaterials() async {
    try {
      final materialsList = await FirebaseUtils.fetchAllMaterials();
      setState(() {
        materials = materialsList;
        filteredMaterials = materials;
        availableQuantities = {
          for (var material in materialsList) material.name!: material.quantity!
        };
        materialUnits = {
          for (var material in materialsList) material.name!: material.unit!
        }; // Store units
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    searchController.removeListener(filterList);
    searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void filterList() {
    List<MaterailModelDto> results = [];
    if (searchController.text.isEmpty) {
      results = materials;
    } else {
      results = materials
          .where((material) => material.name!
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredMaterials = results;
    });
  }

  void updateQuantity(String materialName, int change) {
    setState(() {
      final currentQuantity = selectedQuantities[materialName] ?? 0;
      final newQuantity = currentQuantity + change;
      if (newQuantity >= 0 &&
          newQuantity <= availableQuantities[materialName]!) {
        selectedQuantities[materialName] = newQuantity;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          StringManager.searchMaterial,
          style:
              Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 25.sp),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.solidFloppyDisk,
                color: ColorManager.whiteColor),
            onPressed: () {
              Navigator.pop(context, {
                'selectedQuantities': selectedQuantities,
                'availableQuantities': availableQuantities,
                'materialUnits': materialUnits,
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SlideTransition(
            position: _slideAnimation,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchFieldWidget(
                controller: searchController,
                onChanged: (value) => filterList(),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredMaterials.length,
              itemBuilder: (context, index) {
                final material = filteredMaterials[index];
                final materialName = material.name!;
                final availableQuantity =
                    availableQuantities[materialName] ?? 0;
                final selectedQuantity = selectedQuantities[materialName] ?? 0;
// Get unit

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0.r),
                  child: SearchMaterialItem(
                    isUnavailable: availableQuantity == 0,
                    item: material,
                    availableQuantity: availableQuantity,
                    selectedQuantity: selectedQuantity,
                    onIncrement: () => updateQuantity(materialName, 1),
                    onDecrement: () => updateQuantity(materialName, -1),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 8.0.h);
              },
            ),
          ),
        ],
      ),
    );
  }
}

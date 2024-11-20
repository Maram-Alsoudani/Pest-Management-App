import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Core/utils/firebase_utils.dart';
import 'package:pesticides/Features/inventory/data/models/materail_model_dto.dart';

import '../../../../../Core/component/text_feild_custom.dart';

class SearchMaterialUsageScreen extends StatefulWidget {
  @override
  _SearchMaterialScreenState createState() => _SearchMaterialScreenState();
}

class _SearchMaterialScreenState extends State<SearchMaterialUsageScreen>
    with SingleTickerProviderStateMixin {
  List<MaterailModelDto> materials = [];
  List<MaterailModelDto> filteredMaterials = [];
  Map<String, int> selectedQuantities = {};
  Map<String, int> availableQuantities = {};
  TextEditingController searchController = TextEditingController();
  double _opacity = 0.0;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    fetchMaterials();
    searchController.addListener(filterList);
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _slideAnimation =
        Tween<Offset>(begin: Offset(-1.w, 0), end: Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });
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
      });
      print('Materials fetched: ${materials.length}');
    } catch (e) {
      print('Error fetching materials: $e');
    }
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
      if (newQuantity >= 0) {
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
            icon: const Icon(Icons.save, color: ColorManager.whiteColor),
            onPressed: () {
              Navigator.pop(context, {
                'selectedQuantities': selectedQuantities,
                'availableQuantities': availableQuantities,
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
              child: CustomTextFormField(
                hint: StringManager.searchHint,
                controller: searchController,
                validator: (value) {
                  return null;
                },
                borderRadius: BorderRadius.circular(28.0.r),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filteredMaterials.length,
              itemBuilder: (context, index) {
                final material = filteredMaterials[index];
                final materialName = material.name!;
                final availableQuantity = material.quantity!;
                final selectedQuantity = selectedQuantities[materialName] ?? 0;

                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0.r, vertical: 4.0.r),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0.r),
                    ),
                    elevation: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0.r),
                      child: Container(
                        color: availableQuantity == 0
                            ? ColorManager.greyShade4
                            : ColorManager.whiteColor,
                        child: ListTile(
                          leading: Icon(
                            availableQuantity == 0
                                ? CupertinoIcons.nosign
                                : CupertinoIcons.drop_triangle,
                            color: ColorManager.primaryColor,
                          ),
                          title: Text(
                            materialName,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: ColorManager.blackColor,
                                  decoration: availableQuantity == 0
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                          ),
                          subtitle: Text(
                            'Available: $availableQuantity',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: Colors.grey),
                          ),
                          trailing: availableQuantity > 0
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Visibility(
                                      visible: selectedQuantity > 0,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: IconButton(
                                        icon: Icon(Icons.remove_circle,
                                            size: 20.sp,
                                            color: ColorManager.primaryColor),
                                        onPressed: () {
                                          updateQuantity(materialName, -1);
                                        },
                                      ),
                                    ),
                                    Text(
                                      '$selectedQuantity',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                              color: ColorManager.blackColor),
                                    ),
                                    Visibility(
                                      visible:
                                          selectedQuantity < availableQuantity,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      maintainState: true,
                                      child: IconButton(
                                        icon: Icon(Icons.add_circle,
                                            size: 20.sp,
                                            color: ColorManager.primaryColor),
                                        onPressed: () {
                                          updateQuantity(materialName, 1);
                                        },
                                      ),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      ),
                    ),
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

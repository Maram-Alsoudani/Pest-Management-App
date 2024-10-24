import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/component/text_feild_custom.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';

class SearchMaterialScreen extends StatefulWidget {
  @override
  _SearchMaterialScreenState createState() => _SearchMaterialScreenState();
}

class _SearchMaterialScreenState extends State<SearchMaterialScreen> {
  List<String> materials = [
    'Bleach',
    'Chlorine',
    'Sulfuric Acid',
    'Hydrochloric Acid',
    'Nitric Acid',
    'Funnel Trap',
    'Pyrethroids',
    'Neonicotinoids',
    'Insect Growth Regulators (IGRs)',
    'Boric Acid',
    'Diatomaceous Earth',
    'Glue Traps',
    'Rodent Bait Stations',
    'Insect Light Traps (ILTs)',
    'Pheromone Traps',
    'Termite Bait Systems',
  ];

  List<String> filteredMaterials = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredMaterials = materials;
    searchController.addListener(filterList);
  }

  @override
  void dispose() {
    searchController.removeListener(filterList);
    searchController.dispose();
    super.dispose();
  }

  void filterList() {
    List<String> results = [];
    if (searchController.text.isEmpty) {
      results = materials;
    } else {
      results = materials
          .where((material) => material
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredMaterials = results;
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
      ),
      body: Column(
        children: [
          Padding(
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
          Expanded(
            child: ListView.separated(
              itemCount: filteredMaterials.length,
              itemBuilder: (context, index) {
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
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16.0.r),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          Navigator.pop(context, filteredMaterials[index]);
                        },
                        child: ListTile(
                          leading: const Icon(CupertinoIcons.drop_triangle,
                              color: ColorManager.primaryColor),
                          title: Text(filteredMaterials[index]),
                          trailing: const Icon(Icons.add_circle_outline_rounded,
                              color: ColorManager.blackColor),
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

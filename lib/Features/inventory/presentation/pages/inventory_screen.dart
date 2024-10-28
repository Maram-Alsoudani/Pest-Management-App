import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/core/utils/strings.dart';
import 'package:pesticides/core/utils/colors.dart';
import 'package:pesticides/core/component/text_feild_custom.dart';

class InventoryScreen extends StatefulWidget {
  @override
  _InventoryScreenState createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<InventoryItem> items = [
    InventoryItem(name: 'Bleach', quantity: 10),
    InventoryItem(name: 'Chlorine', quantity: 5),
    InventoryItem(name: 'Sulfuric Acid', quantity: 20),
    InventoryItem(name: 'Hydrochloric Acid', quantity: 15),
    InventoryItem(name: 'Nitric Acid', quantity: 0),
    InventoryItem(name: 'Funnel Trap', quantity: 12),
    InventoryItem(name: 'Pyrethroids', quantity: 7),
    InventoryItem(name: 'Neonicotinoids', quantity: 9),
    InventoryItem(name: 'Insect Growth Regulators (IGRs)', quantity: 11),
    InventoryItem(name: 'Boric Acid', quantity: 14),
    InventoryItem(name: 'Diatomaceous Earth', quantity: 6),
    InventoryItem(name: 'Glue Traps', quantity: 13),
    InventoryItem(name: 'Rodent Bait Stations', quantity: 4),
    InventoryItem(name: 'Insect Light Traps (ILTs)', quantity: 3),
    InventoryItem(name: 'Pheromone Traps', quantity: 2),
    InventoryItem(name: 'Termite Bait Systems', quantity: 0),
  ];

  List<InventoryItem> filteredItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = items;
    searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterItems);
    searchController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      filteredItems = items
          .where((item) => item.name
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          StringManager.inventory,
          style:
              Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 25.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0.r),
        child: Column(
          children: [
            CustomTextFormField(
              hint: StringManager.searchHint,
              controller: searchController,
              validator: (value) {
                return null;
              },
              borderRadius: BorderRadius.circular(26.0.r),
            ),
            SizedBox(height: 6.0.h),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  final isUnavailable = item.quantity == 0;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0.r),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0.r),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isUnavailable
                              ? ColorManager.greyShade4
                              : ColorManager.whiteColor,
                          borderRadius: BorderRadius.circular(16.0.r),
                        ),
                        child: ListTile(
                          leading: Icon(
                            isUnavailable
                                ? CupertinoIcons.nosign
                                : CupertinoIcons.drop_triangle,
                            color: ColorManager.primaryColor,
                          ),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              color: isUnavailable
                                  ? ColorManager.greyShade3
                                  : Colors.black,
                              decoration: isUnavailable
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: Text('Quantity: ${item.quantity}'),
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
    );
  }
}

class InventoryItem {
  final String name;
  final int quantity;

  InventoryItem({required this.name, required this.quantity});
}

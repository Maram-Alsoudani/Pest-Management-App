import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pesticides/Core/component/button_custom.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'search_material_screen.dart';

class MaterialUsageScreen extends StatefulWidget {
  @override
  _MaterialUsageScreenState createState() => _MaterialUsageScreenState();
}

class _MaterialUsageScreenState extends State<MaterialUsageScreen> {
  List<String> materials = [];

  void addItem(String item) {
    setState(() {
      materials.add(item);
    });
  }

  void removeItem(String item) {
    setState(() {
      materials.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          StringManager.materialUsages,
          style:
              Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 25.sp),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: materials.length,
                itemBuilder: (context, index) {
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
                          key: ValueKey(materials[index]),
                          endActionPane: ActionPane(
                            dragDismissible: false,
                            motion: const BehindMotion(),
                            extentRatio: 0.25,
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  removeItem(materials[index]);
                                },
                                backgroundColor: ColorManager.redColor,
                                foregroundColor: ColorManager.whiteColor,
                                icon: CupertinoIcons.delete,
                                label: StringManager.delete,
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: const Icon(CupertinoIcons.drop_triangle,
                                color: ColorManager.primaryColor),
                            title: Text(materials[index]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0.h),
            Center(
              child: SizedBox(
                width: 200.w,
                child: ButtonCustom(
                  buttonName: StringManager.addMaterial,
                  textStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  onTap: () async {
                    final newItem = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchMaterialScreen(),
                      ),
                    );
                    if (newItem != null) {
                      addItem(newItem);
                    }
                  },
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

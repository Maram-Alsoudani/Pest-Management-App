import 'package:flutter/material.dart';

import '../../../../Core/utils/colors.dart';
import 'custom_text.dart';

class AddMaterial extends StatefulWidget {
  List<String> chooseList;
  String title;
  AddMaterial({super.key, required this.chooseList, required this.title});

  @override
  State<AddMaterial> createState() => _AddMaterialState();
}

class _AddMaterialState extends State<AddMaterial> {
  List<String> showMaterialsList = [];

  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(title: widget.title),
              PopupMenuButton<String>(
                icon: const Icon(Icons.add), // Replace with any icon you prefer
                onSelected: (value) {
                  setState(() {
                    showMaterialsList.add(value);
                  });
                },
                itemBuilder: (context) {
                  return widget.chooseList.map((item) {
                    return PopupMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList();
                },
              ),

              //todo we can also use this
              /* DropdownButton<String>(
                      icon: Icon(Icons.add),
                      items: materialsList.map((item) {
                        return DropdownMenuItem(value: item, child: Text(item));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedItem = value;
                        });
                        if (showMaterialsList.contains(value)) return;
                        if (selectedItem != null &&
                            materialsList.contains(selectedItem)) {
                          setState(() {
                            showMaterialsList.add(selectedItem!);
                            selectedItem = null;
                          });
                        }
                      }),*/
            ],
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: showMaterialsList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: ColorManager.redColor,
                        ),
                        onPressed: () {
                          setState(() {
                            showMaterialsList.removeAt(index);
                          });
                        },
                      ),
                      title: Text(
                        showMaterialsList[index],
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}

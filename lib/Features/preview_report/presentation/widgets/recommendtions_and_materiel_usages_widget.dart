import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'title_divider_widget.dart';

class MaterialUsagesAndRecommendtions extends StatelessWidget {
  final String title;
  final Map<String, int> materials;
  final double opacity;
  final Animation<Offset> position;

  const MaterialUsagesAndRecommendtions({
    super.key,
    required this.materials,
    required this.title,
    required this.opacity,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitleWithDivider(title: title),
          SizedBox(
            height: 100.h,
            child: SlideTransition(
              position: position,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: materials.length,
                itemBuilder: (context, index) {
                  final materialName = materials.keys.elementAt(index);
                  final quantity = materials[materialName]!;
                  return Text("${index + 1}- $materialName: $quantity",
                      style: Theme.of(context).textTheme.titleMedium);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

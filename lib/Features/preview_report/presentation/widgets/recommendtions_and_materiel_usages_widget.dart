
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/strings.dart';

class MaterialUsagesAndRecommendtions extends StatelessWidget {
  final String tilte;
  final List<String>text;
  final double opacity;
  final Animation<Offset> position;
  const MaterialUsagesAndRecommendtions({super.key, required this.text, required this.tilte, required this.opacity, required this.position});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  EdgeInsets.symmetric(vertical: 12.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedOpacity(
            duration: const Duration(seconds: 2),
            opacity: opacity,
            curve: Curves.easeIn,
            child: Text(tilte,
                style: Theme.of(context).textTheme.bodyLarge),
          ),
          SizedBox(
            height: 100.h,
            child: SlideTransition(
              position: position,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: text.length,
                itemBuilder: (context, index) {
                  return ListTile(

                    leading: Text(
                      '${index+1}-', // Black dot symbol
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    title: Text(text[index],
                        style: Theme.of(context).textTheme.bodyMedium
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

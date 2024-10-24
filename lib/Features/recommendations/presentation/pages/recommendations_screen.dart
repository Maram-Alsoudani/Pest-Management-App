import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/recommendations/presentation/widgets/recommendations_custome.dart';

class RecommendationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.recommendationsScreenName),
        actions: [
          Padding(
            padding:  EdgeInsets.only(right: 22.w),
            child: Icon(
              (Icons.save),
              color: ColorManager.primaryColor,
            ),
          )
        ],
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RecommendationsCustome(text: 'Air curtain must be maintained',),
            RecommendationsCustome(text: 'Air curtain must be maintained',),
            RecommendationsCustome(text: 'Air curtain must be maintained',),
            RecommendationsCustome(text: 'Air curtain must be maintained',),
            RecommendationsCustome(text: 'Air curtain must be maintained',),
            RecommendationsCustome(text: 'Air curtain must be maintained',),
            RecommendationsCustome(text: 'Air curtain must be maintained',),
            RecommendationsCustome(text: 'Air curtain must be maintained',),
            RecommendationsCustome(text: 'Air curtain must be maintained',),
            RecommendationsCustome(text: 'Air curtain must be maintained',),
          ],
        ),
      ),
    );
  }
}

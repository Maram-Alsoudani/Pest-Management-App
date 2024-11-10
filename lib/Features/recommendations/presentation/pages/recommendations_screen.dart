import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/recommendations/presentation/widgets/recommendations_custome.dart';

class RecommendationsScreen extends StatefulWidget {
  @override
  _RecommendationsScreenState createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations;
  final List<String> recommendations = List.generate(
      10, (index) => 'Air curtain must be maintained$index');

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _slideAnimations = List.generate(recommendations.length, (index) {
      return Tween<Offset>(
        begin: Offset(-1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.1,
            1.0,
            curve: Curves.easeOut,
          ),
        ),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.recommendationsScreenName),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 22.w),
            child: Icon(
              Icons.save,
              color: ColorManager.primaryColor,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 25.w, right: 10.w),
        child: ListView.builder(
          itemCount: recommendations.length,
          itemBuilder: (context, index) {

            return SlideTransition(
              position: _slideAnimations[index],
              child: RecommendationsCustome(
                text: recommendations[index],
              ),
            );
          },
        ),
      ),
    );
  }
}

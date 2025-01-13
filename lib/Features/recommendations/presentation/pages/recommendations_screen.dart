import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/site_report/presentation/manager/report_view_model.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  _RecommendationsScreenState createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<Offset>> _slideAnimations;
  final List<String> recommendations =
      List.generate(10, (index) => 'Recommendation $index');
  late List<bool> selectedRecommendations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimations = List.generate(recommendations.length, (index) {
      return Tween<Offset>(
        begin: const Offset(-1, 0),
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

    // Initialize selectedRecommendations based on the saved state
    final reportViewModel = context.read<ReportViewModel>();
    selectedRecommendations = recommendations
        .map((recommendation) =>
            reportViewModel.recommendations.contains(recommendation))
        .toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportViewModel = context.read<ReportViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(StringManager.recommendations),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: ColorManager.whiteColor),
            onPressed: () {
              final selected = recommendations
                  .asMap()
                  .entries
                  .where((entry) => selectedRecommendations[entry.key])
                  .map((entry) => entry.value)
                  .toList();
              reportViewModel.updateRecommendations(selected);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.r),
        child: Column(
          children: [
            Expanded(
              child: SlideTransition(
                position: _slideAnimations[0],
                child: ListView.builder(
                  itemCount: recommendations.length,
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
                            key: ValueKey(recommendations[index]),
                            endActionPane: ActionPane(
                              dragDismissible: false,
                              motion: const BehindMotion(),
                              extentRatio: 0.25,
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    setState(() {
                                      selectedRecommendations[index] =
                                          !selectedRecommendations[index];
                                    });
                                  },
                                  backgroundColor:
                                      selectedRecommendations[index]
                                          ? ColorManager.redColor
                                          : ColorManager.primaryColor,
                                  foregroundColor: ColorManager.whiteColor,
                                  icon: selectedRecommendations[index]
                                      ? CupertinoIcons.check_mark
                                      : CupertinoIcons.add,
                                  label: selectedRecommendations[index]
                                      ? StringManager.remove
                                      : StringManager.add,
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: selectedRecommendations[index]
                                  ? const Icon(Icons.thumb_up_alt,
                                      color: ColorManager.primaryColor)
                                  : const Icon(Icons.chevron_right_rounded),
                              title: Text(
                                recommendations[index],
                                style: TextStyle(
                                  color: selectedRecommendations[index]
                                      ? ColorManager.primaryColor
                                      : Colors.black,
                                  decoration: selectedRecommendations[index]
                                      ? TextDecoration.underline
                                      : TextDecoration.none,
                                ),
                              ),
                              trailing: Checkbox(
                                activeColor: ColorManager.primaryColor,
                                value: selectedRecommendations[index],
                                onChanged: (value) {
                                  setState(() {
                                    selectedRecommendations[index] = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
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

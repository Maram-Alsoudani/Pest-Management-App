import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pesticides/Core/utils/images.dart';
import 'package:pesticides/Features/preview_report/presentation/widgets/location_widget.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Features/preview_report/presentation/widgets/photos_widget.dart';

import '../../../../Core/utils/strings.dart';
import '../widgets/device_widget.dart';
import '../widgets/recommendtions_and_materiel_usages_widget.dart';

class PreviewReportScreen extends StatefulWidget {
  PreviewReportScreen({super.key});

  @override
  State<PreviewReportScreen> createState() => _PreviewReportScreenState();
}

class _PreviewReportScreenState extends State<PreviewReportScreen> with SingleTickerProviderStateMixin {
  final List<String> rec = [
    'Air curtain must be maintained',
    'Bait Stations are without baits',
    'Bathroom Unsanitary / Please Sanitize',
    'Bathroom Unsanitary / Please Sanitize ',
  ];

  final List<String> mat = [
    'Funnel Trap * 1',
    'Funnel Trap * 2',
    'Funnel Trap * 3',
    'Funnel Trap * 4',
  ];
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  double _opacity = 0.0;
  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _slideAnimation =
        Tween<Offset>(begin:  Offset(-1.w, 0), end: const Offset(0, 0)).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        );

    // Trigger the slide animation after the page loads
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _opacity = 1.0;
      });


      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(StringManager.previewReport,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(fontSize: 25.sp)),
          actions: [
            Padding(
              padding: EdgeInsets.all(15.r),
              child: const InkWell(
                child: Icon(
                  Icons.send,
                  color: ColorManager.primaryColor,
                ),
              ),
            )
          ],
        ),
        body: Container(
          width: 500.w,
          margin: EdgeInsets.all(15.r),
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
              color: ColorManager.whiteColor,
              borderRadius: BorderRadius.circular(15.r),
              image: const DecorationImage(
                  opacity: 0.5,
                  image: AssetImage(
                    ImageManager.report,
                  ))),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedOpacity(
                  duration: const Duration(seconds: 2),
                  opacity: _opacity,
                  curve: Curves.easeIn,
                  child: const LocationWidget(
                    location: "Carrefour , Maddi",
                  ),
                ),
                const Divider(),
                MaterialUsagesAndRecommendtions(
                  position: _slideAnimation,
                  opacity: _opacity,
                  text: rec,
                  tilte: StringManager.recommendations,
                ),
                const Divider(),
                MaterialUsagesAndRecommendtions(
                  position: _slideAnimation,
                  opacity: _opacity,
                  text: mat,
                  tilte: StringManager.materialUsages,
                ),
                const Divider(),
                PhotosWidget(
                  opacity: _opacity,
                  position: _slideAnimation,
                ),
                const Divider(),
                DeviceWidget(
                  opacity: _opacity,
                  position: _slideAnimation,

                ),
                const Divider(),
                AnimatedOpacity(
                  duration: const Duration(seconds: 2),
                  opacity: _opacity,
                  curve: Curves.easeIn,
                  child: Text("${StringManager.notes}:  ",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                SlideTransition(
                  position: _slideAnimation,
                  child: Text("Noting Come Easy/////////////////////////////////////////",
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                SizedBox(height: 40.h,),
                const Divider(),
                AnimatedOpacity(
                  duration: const Duration(seconds: 2),
                  opacity: _opacity,
                  curve: Curves.easeIn,
                  child: Text("${StringManager.conditions}:",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                SlideTransition(
                  position: _slideAnimation,
                  child: Text("Noting Come Easy/////////////////////////////////////////",
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                SizedBox(height: 40.h,),
                const Divider(),
                AnimatedOpacity(
                  duration: const Duration(seconds: 2),
                  opacity: _opacity,
                  curve: Curves.easeIn,
                  child: Text("${StringManager.signatures}:",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),



              ],
            ),
          ),
        ),
      ),
    );
  }
}

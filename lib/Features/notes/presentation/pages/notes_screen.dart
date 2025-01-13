import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/site_report/presentation/manager/report_view_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with SingleTickerProviderStateMixin {
  final int maxCharacters = 500;
  String inputText = '';
  final TextEditingController _notesController = TextEditingController();

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 2.h), end: const Offset(0, 0)).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Trigger the slide animation after the page loads
    Future.delayed(const Duration(milliseconds: 300), () {
      _animationController.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reportViewModel = context.read<ReportViewModel>();
    _notesController.text = reportViewModel.notes;
  }

  @override
  void dispose() {
    _animationController.dispose(); // Clean up the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportViewModel = context.read<ReportViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(StringManager.notes,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontSize: 25.sp)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.sp),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Add SlideTransition for the TextField
              SlideTransition(
                position: _slideAnimation,
                child: TextField(
                  controller: _notesController,
                  maxLength: maxCharacters,
                  onChanged: (text) {
                    setState(() {
                      inputText = text;
                    });
                    reportViewModel.updateNotes(text);
                  },
                  cursorColor: ColorManager.primaryColor,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: ColorManager.whiteColor,
                    hintText: StringManager.enterNotes,
                    hintStyle: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: ColorManager.greyShade4),
                    counterStyle: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: ColorManager.greyShade4),
                  ),
                  maxLines: 15,
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _notesController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                    textStyle: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(
                    'Save Notes',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

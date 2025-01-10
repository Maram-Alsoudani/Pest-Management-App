import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/site_report/presentation/manager/report_view_model.dart';

import 'signature_pad.dart';

class SignaturesScreen extends StatefulWidget {
  const SignaturesScreen({super.key});

  @override
  State<SignaturesScreen> createState() => _SignaturesScreenState();
}

class _SignaturesScreenState extends State<SignaturesScreen> {
  List<File> signaturesList = [];
  List<int> selectedIndices = [];
  bool isMultiSelectMode = false;

  @override
  void initState() {
    super.initState();
    final reportViewModel = context.read<ReportViewModel>();
    signaturesList =
        reportViewModel.signatures.map((path) => File(path)).toList();
  }

  Future<void> addNewSignature() async {
    clearAllSelected();
    final result = await Navigator.push(
      context,
      PullFromButtonPageRoute(page: const SignaturePad()),
    );
    if (result != null && result is Uint8List) {
      final file = await saveSignature(result);
      setState(() {
        signaturesList.add(file);
      });
      final reportViewModel = context.read<ReportViewModel>();
      reportViewModel
          .updateSignatures(signaturesList.map((e) => e.path).toList());
    }
  }

  Future<File> saveSignature(Uint8List data) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
        '${directory.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png');
    return file.writeAsBytes(data);
  }

  void deleteSelected() {
    setState(() {
      selectedIndices.sort((a, b) => b.compareTo(a));
      for (var index in selectedIndices) {
        signaturesList.removeAt(index);
      }
      selectedIndices.clear();
      isMultiSelectMode = false;
    });
    final reportViewModel = context.read<ReportViewModel>();
    reportViewModel
        .updateSignatures(signaturesList.map((e) => e.path).toList());
  }

  void selectAll() {
    setState(() {
      selectedIndices = List.generate(signaturesList.length, (index) => index);
      isMultiSelectMode = true;
    });
  }

  void clearAllSelected() {
    setState(() {
      selectedIndices.clear();
      isMultiSelectMode = false;
    });
  }

  void toggleSelection(int index) {
    setState(() {
      if (selectedIndices.contains(index)) {
        selectedIndices.remove(index);
      } else {
        selectedIndices.add(index);
      }
      isMultiSelectMode = selectedIndices.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportViewModel = context.read<ReportViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(isMultiSelectMode
            ? '${selectedIndices.length} ${StringManager.selected}'
            : StringManager.signatures),
        actions: isMultiSelectMode
            ? [
                IconButton(
                    icon: const Icon(Icons.select_all), onPressed: selectAll),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: deleteSelected,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: clearAllSelected,
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.save, color: ColorManager.whiteColor),
                  onPressed: () {
                    reportViewModel.updateSignatures(
                        signaturesList.map((e) => e.path).toList());
                    Navigator.pop(context);
                  },
                ),
              ],
      ),
      body: signaturesList.isEmpty
          ? const Center(
              child: Text(
                StringManager.noSignatures,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            )
          : GridView.builder(
              itemCount: signaturesList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (context, index) {
                final isSelected = selectedIndices.contains(index);
                return GestureDetector(
                  onTap: () {
                    if (isMultiSelectMode) {
                      toggleSelection(index);
                    }
                  },
                  onLongPress: () {
                    toggleSelection(index);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? ColorManager.primaryColor
                            : Colors.transparent,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Image.file(signaturesList[index]),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorManager.primaryColor,
        shape: const CircleBorder(),
        onPressed: addNewSignature,
        child: const Icon(
          Icons.add,
          color: ColorManager.whiteColor,
          size: 30,
        ),
      ),
    );
  }
}

class PullFromButtonPageRoute extends PageRouteBuilder {
  final Widget page;

  PullFromButtonPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        );
}

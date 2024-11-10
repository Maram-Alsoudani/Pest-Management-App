import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Features/signatures/presentation/pages/signature_pad.dart';

class SignaturesScreen extends StatefulWidget {
  SignaturesScreen({super.key});

  @override
  State<SignaturesScreen> createState() => _SignaturesScreenState();
}

class _SignaturesScreenState extends State<SignaturesScreen> {
  List<Uint8List> signaturesList = [];
  List<int> selectedIndices = [];
  bool isMultiSelectMode = false;

  Future<void> addNewSignature() async {
    clearAllSelected();
    final result = await Navigator.push(
      context,
      PullFromButtonPageRoute(page: SignaturePad()),
    );
    if (result != null) {
      setState(() {
        signaturesList.add(result);
      });
    }
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
  }

  void selectAll() {
    for (int i = 0; i <= signaturesList.length; i++) {
      selectedIndices.add(i);
    }
    setState(() {});
  }

  void clearAllSelected() {
    setState(() {
      selectedIndices.clear();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(isMultiSelectMode
            ? '${selectedIndices.length} Selected'
            : 'Signatures'),
        actions: isMultiSelectMode
            ? [
                IconButton(icon: Icon(Icons.select_all), onPressed: selectAll),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: deleteSelected,
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: clearAllSelected,
                ),
              ]
            : null,
      ),
      body: signaturesList.isEmpty
          ? Center(
              child: Text(
                "No signatures added yet",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            )
          : GridView.builder(
              itemCount: signaturesList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (context, index) {
                final isSelected = selectedIndices.contains(index);
                return GestureDetector(
                  onLongPress: () {
                    setState(() {
                      isMultiSelectMode = true;
                      selectedIndices.add(index);
                    });
                  },
                  onTap: () {
                    if (isMultiSelectMode) {
                      setState(() {
                        toggleSelection(index);
                      });
                    }
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            border: isSelected
                                ? Border.all(
                                    color: ColorManager.primaryColor, width: 3)
                                : null,
                          ),
                          child: Image.memory(
                            signaturesList[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Icon(
                            Icons.check_circle,
                            color: ColorManager.primaryColor,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: ColorManager.whiteColor,
          size: 30,
        ),
        backgroundColor: ColorManager.primaryColor,
        shape: CircleBorder(),
        onPressed: addNewSignature,
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

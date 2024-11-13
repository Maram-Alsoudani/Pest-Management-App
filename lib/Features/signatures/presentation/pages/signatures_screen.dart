import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Features/signatures/presentation/manager/states.dart';

import '../manager/signatures_view_model.dart';
import 'signature_pad.dart';

class SignaturesScreen extends StatefulWidget {
  SignaturesScreen({super.key});

  @override
  State<SignaturesScreen> createState() => _SignaturesScreenState();
}

class _SignaturesScreenState extends State<SignaturesScreen> {
  SignaturesViewModel viewModel = SignaturesViewModel();

  Future<void> addNewSignature(BuildContext context) async {
    var result = await Navigator.push(
      context,
      PullFromButtonPageRoute(page: SignaturePad()),
    );
    if (result != null && result is Uint8List) {
      viewModel.addNewSignature(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => viewModel,
      child: BlocBuilder<SignaturesViewModel, SignaturesState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(viewModel.isMultiSelectMode
                  ? '${viewModel.selectedIndices.length} Selected'
                  : 'Signatures'),
              actions: viewModel.isMultiSelectMode
                  ? [
                      IconButton(
                          icon: Icon(Icons.select_all),
                          onPressed: viewModel.selectAll),
                      IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: viewModel.deleteSelected),
                      IconButton(
                          icon: Icon(Icons.close),
                          onPressed: viewModel.clearAllSelected),
                    ]
                  : null,
            ),
            body: viewModel.signaturesList.isEmpty
                ? Center(
                    child: Text(
                "No signatures added yet",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            )
                : GridView.builder(
                    itemCount: viewModel.signaturesList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (context, index) {
                      final isSelected =
                          viewModel.selectedIndices.contains(index);
                      return GestureDetector(
                  onLongPress: () {
                          viewModel.toggleSelection(index);
                        },
                  onTap: () {
                          if (viewModel.isMultiSelectMode) {
                            viewModel.toggleSelection(index);
                          }
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: isSelected
                                      ? Border.all(
                                          color: ColorManager.primaryColor,
                                          width: 3)
                                      : null,
                          ),
                          child: Image.memory(
                                  viewModel.signaturesList[index].imageData
                                      as Uint8List,
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
              onPressed: () => addNewSignature(context),
              child: Icon(Icons.add, color: ColorManager.whiteColor, size: 30),
              backgroundColor: ColorManager.primaryColor,
            ),
          );
        },
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

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        );
}

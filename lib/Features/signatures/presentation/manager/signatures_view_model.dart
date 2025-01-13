import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bug_away/Features/signatures/presentation/manager/states.dart';

import '../../domain/entities/signature_entity.dart';

class SignaturesViewModel extends Cubit<SignaturesState> {
  List<SignatureEntity> signaturesList = [];
  List<int> selectedIndices = [];
  bool isMultiSelectMode = false;

  SignaturesViewModel() : super(SignaturesInitialState());

  // to Add a new signature
  void addNewSignature(Uint8List signatureData) {
    signaturesList.add(SignatureEntity(imageData: signatureData));
    emit(SignaturesSuccessState(
      signaturesList: signaturesList,
      selectedIndices: selectedIndices,
      isMultiSelectMode: isMultiSelectMode,
    ));
  }

  // to delete selected signatures
  void deleteSelected() {
    selectedIndices.sort((a, b) => b.compareTo(a));
    for (var index in selectedIndices) {
      signaturesList.removeAt(index);
    }
    selectedIndices.clear();
    isMultiSelectMode = false;
    emit(SignaturesSuccessState(
      signaturesList: signaturesList,
      selectedIndices: selectedIndices,
      isMultiSelectMode: isMultiSelectMode,
    ));
  }

  // toggle selection for a specific index
  void toggleSelection(int index) {
    if (selectedIndices.contains(index)) {
      selectedIndices.remove(index);
    } else {
      selectedIndices.add(index);
    }
    isMultiSelectMode = selectedIndices.isNotEmpty;
    emit(SignaturesSuccessState(
      signaturesList: signaturesList,
      selectedIndices: selectedIndices,
      isMultiSelectMode: isMultiSelectMode,
    ));
  }

  // select all signatures
  void selectAll() {
    selectedIndices = List.generate(signaturesList.length, (index) => index);
    isMultiSelectMode = true;
    emit(SignaturesSuccessState(
      signaturesList: signaturesList,
      selectedIndices: selectedIndices,
      isMultiSelectMode: isMultiSelectMode,
    ));
  }

  // clear all selected
  void clearAllSelected() {
    selectedIndices.clear();
    isMultiSelectMode = false;
    emit(SignaturesSuccessState(
      signaturesList: signaturesList,
      selectedIndices: selectedIndices,
      isMultiSelectMode: isMultiSelectMode,
    ));
  }
}

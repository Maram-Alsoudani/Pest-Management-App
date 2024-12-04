import 'package:bug_away/Features/signatures/domain/entities/signature_entity.dart';

abstract class SignaturesState {
  const SignaturesState();
}

class SignaturesInitialState extends SignaturesState {
  SignaturesInitialState();
}

class SignaturesLoadingState extends SignaturesState {
  const SignaturesLoadingState();
}

class SignaturesSuccessState extends SignaturesState {
  final List<SignatureEntity> signaturesList;
  final List<int> selectedIndices;
  final bool isMultiSelectMode;

  const SignaturesSuccessState({
    required this.signaturesList,
    required this.selectedIndices,
    required this.isMultiSelectMode,
  });
}

class SignaturesErrorState extends SignaturesState {
  final String errorMessage;

  const SignaturesErrorState({required this.errorMessage});
}

class SignaturesEmptyState extends SignaturesState {
  const SignaturesEmptyState();
}

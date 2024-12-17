import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Features/category/domin/repo/category_repo.dart';

import '../../../../Core/errors/failures.dart';

@injectable
class EditImageInFireStoreUseCase {
  CategoryRepo categoryRepo;
  EditImageInFireStoreUseCase({required this.categoryRepo});

  Future<Either<Failure, void>> invoke(String? image) {
    return categoryRepo.editImage(image);
  }
}

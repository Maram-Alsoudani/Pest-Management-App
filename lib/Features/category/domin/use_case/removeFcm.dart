import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/category/domin/repo/category_repo.dart';

@injectable
class RemoveFcmFromFireStore {
  CategoryRepo categoryRepo;
  RemoveFcmFromFireStore({required this.categoryRepo});

  Future<Either<Failure, void>> invoke() {
    return categoryRepo.removeFcm();
  }
}

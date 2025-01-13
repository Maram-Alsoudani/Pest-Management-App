import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Features/category/domin/repo/category_repo.dart';

import '../../../../Core/errors/failures.dart';
import '../../../register/domain/entities/user_model_entity.dart';

@injectable
class ReadUserOrAdminFromFireStoreUseCase {
  CategoryRepo categoryRepo;
  ReadUserOrAdminFromFireStoreUseCase({required this.categoryRepo});

  Future<Either<Failure, UserAndAdminModelEntity>> invoke() {
    return categoryRepo.readUserOrAdminFromFireStore();
  }
}

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/reports/domain/repositories/get_users_repo.dart';

import '../../../register/domain/entities/user_model_entity.dart';

@injectable
class GetUsersUseCase {
  GetUsersRepo getUsersRepo;

  GetUsersUseCase({required this.getUsersRepo});

  Future<Either<Failure, List<UserAndAdminModelEntity>>> invoke() {
    return getUsersRepo.getUsersFromFireStore();
  }
}

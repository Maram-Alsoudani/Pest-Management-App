import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/reports/domain/repositories/get_users_repo.dart';

import '../../../register/domain/entities/user_model_entity.dart';

@injectable
class GetUsersUseCase {
  GetUsersRepo getUsersRepo;

  GetUsersUseCase({required this.getUsersRepo});

  Future<Either<Failure, List<UserAndAdminModelEntity>>> invoke() {
    return getUsersRepo.getUsersFromFireStore();
  }
}

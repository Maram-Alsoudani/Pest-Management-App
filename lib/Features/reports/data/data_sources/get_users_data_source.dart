import 'package:dartz/dartz.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/register/domain/entities/user_model_entity.dart';

abstract class GetUsersDataSource {
  Future<Either<Failure, List<UserAndAdminModelEntity>>>
      getUsersFromFireStore();
}

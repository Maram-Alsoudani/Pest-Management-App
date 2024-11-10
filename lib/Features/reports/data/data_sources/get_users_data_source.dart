import 'package:dartz/dartz.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/register/domain/entities/user_model_entity.dart';

abstract class GetUsersDataSource {
  Future<Either<Failure, List<UserAndAdminModelEntity>>>
      getUsersFromFireStore();
}

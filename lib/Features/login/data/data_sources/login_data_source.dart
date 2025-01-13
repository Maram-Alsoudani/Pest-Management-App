import 'package:dartz/dartz.dart';
import 'package:bug_away/Features/register/data/models/user_model_dto.dart';

import '../../../../Core/errors/failures.dart';

abstract class LoginDataSource {
  Future<Either<Failure, UserAndAdminModelDto?>> login(
      String email, String password, String? type);
}

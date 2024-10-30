import 'package:dartz/dartz.dart';
import 'package:pesticides/Features/register/data/models/user_model_dto.dart';

import '../../../../Core/errors/failures.dart';

abstract class LoginDataSource {
  Future<Either<Failure, UserAndAdminModelDto?>> getUserFromFireStore(
      String type, String id);
}

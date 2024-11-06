import 'package:dartz/dartz.dart';

import '../../../../Core/errors/failures.dart';
import '../../../register/domain/entities/user_model_entity.dart';

abstract class LoginRepository {
  Future<Either<Failure, UserAndAdminModelEntity?>> getUserFromFireStore(
      String type, String id);
}

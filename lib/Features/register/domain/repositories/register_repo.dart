import 'package:dartz/dartz.dart';

import '../../../../Core/errors/failures.dart';

abstract class RegisterRepo {
  Future<Either<Failure, void>> registerFireStore(String image, String type,
      String userName, String phone, String email, String password);
}

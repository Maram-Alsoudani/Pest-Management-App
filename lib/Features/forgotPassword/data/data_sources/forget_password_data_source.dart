import 'package:dartz/dartz.dart';
import 'package:pesticides/Core/errors/failures.dart';

abstract class ForgetPasswordDataSource {
  Future<Either<Failure, void>> forgetPassword(String email);
}

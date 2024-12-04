import 'package:dartz/dartz.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/forgotPassword/domain/entities/forget_password_entity.dart';

abstract class ForgetPasswordRepository {
  Future<Either<Failure, void>> forgetPassword(String email);
}

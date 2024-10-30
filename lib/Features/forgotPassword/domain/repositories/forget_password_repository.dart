import 'package:dartz/dartz.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/forgotPassword/domain/entities/forget_password_entity.dart';


abstract class ForgetPasswordRepository {
  Future<Either<Failure, void>> forgetPassword(String email);
}

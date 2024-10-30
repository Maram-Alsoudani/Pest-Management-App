import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/forgotPassword/domain/repositories/forget_password_repository.dart';

@injectable
class ForgetPasswordUserCase {
  ForgetPasswordRepository forgetPasswordRepository;

  ForgetPasswordUserCase({required this.forgetPasswordRepository});

  Future<Either<Failure, void>> invoke(String email) {
    return forgetPasswordRepository.forgetPassword(email);
  }
}

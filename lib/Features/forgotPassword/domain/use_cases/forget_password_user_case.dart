import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/forgotPassword/domain/repositories/forget_password_repository.dart';

@injectable
class ForgetPasswordUserCase {
  ForgetPasswordRepository forgetPasswordRepository;

  ForgetPasswordUserCase({required this.forgetPasswordRepository});

  Future<Either<Failure, void>> invoke(String email) {
    return forgetPasswordRepository.forgetPassword(email);
  }
}

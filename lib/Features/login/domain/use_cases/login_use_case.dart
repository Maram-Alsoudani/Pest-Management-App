import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Features/login/domain/repositories/login_repository.dart';

import '../../../../Core/errors/failures.dart';
import '../../../register/domain/entities/user_model_entity.dart';

@injectable
class LoginUseCase {
  LoginRepository loginRepository;
  LoginUseCase({required this.loginRepository});

  Future<Either<Failure, UserAndAdminModelEntity?>> invoke(
      String email, String password, String? type) {
    return loginRepository.login(email, password, type);
  }
}

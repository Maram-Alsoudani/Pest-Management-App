import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Features/login/domain/repositories/login_repository.dart';

import '../../../../Core/errors/failures.dart';
import '../../../register/domain/entities/user_model_entity.dart';

@injectable
class LoginUseCase {
  LoginRepository loginRepository;
  LoginUseCase({required this.loginRepository});

  Future<Either<Failure, UserAndAdminModelEntity?>> invoke(String type,
      String email) {
    return loginRepository.getUserFromFireStore(type, email);
  }
}

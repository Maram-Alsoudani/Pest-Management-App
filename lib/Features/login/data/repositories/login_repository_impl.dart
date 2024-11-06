import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../Core/errors/failures.dart';
import '../../../register/domain/entities/user_model_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../data_sources/login_data_source.dart';

@Injectable(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  LoginDataSource loginDataSource;
  LoginRepositoryImpl({required this.loginDataSource});

  @override
  Future<Either<Failure, UserAndAdminModelEntity?>> login(
      String email, String password, String? type) async {
    var either = await loginDataSource.login(email, password, type);
    return either.fold((error) => Left(error), (user) => Right(user));
  }
}

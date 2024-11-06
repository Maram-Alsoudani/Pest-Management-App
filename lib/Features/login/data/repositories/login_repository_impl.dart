import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/login/data/data_sources/login_data_source.dart';
import 'package:pesticides/Features/login/domain/repositories/login_repository.dart';

import '../../../register/domain/entities/user_model_entity.dart';

@Injectable(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  LoginDataSource loginDataSource;

  LoginRepositoryImpl({required this.loginDataSource});

  @override
  Future<Either<Failure, UserAndAdminModelEntity?>> getUserFromFireStore(
      String type, String id) async {
    var either = await loginDataSource.getUserFromFireStore(type, id);
    return either.fold((error) => Left(error), (response) => Right(response));
  }
}

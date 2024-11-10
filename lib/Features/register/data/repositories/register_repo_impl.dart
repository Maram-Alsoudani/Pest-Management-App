import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/register/data/data_source/data/register_data_source.dart';

import 'package:pesticides/Features/register/domain/entities/user_model_entity.dart';

import '../../domain/repositories/register_repo.dart';

@Injectable(as: RegisterRepo)
class RegisterRepoImpl implements RegisterRepo {
  RegisterDataSource registerDataSource;
  RegisterRepoImpl({required this.registerDataSource});

  @override
  Future<Either<Failure, void>> registerFireStore(String image, String type, String userName, String phone, String email,String password)async {
    var either = await registerDataSource.registerAuth(image, type, userName, phone, email, password);

    return either.fold((error) => Left(error), (response) => Right(response));
  }

}

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/register/data/data_source/data/register_data_source.dart';

import '../../domain/repositories/register_repo.dart';

@Injectable(as: RegisterRepo)
class RegisterRepoImpl implements RegisterRepo {
  RegisterDataSource registerDataSource;
  RegisterRepoImpl({required this.registerDataSource});

  @override
  Future<Either<Failure, void>> registerFireStore(String image, String type,
      String userName, String phone, String email, String password) async {
    var either = await registerDataSource.registerAuth(
        image, type, userName, phone, email, password);

    return either.fold((error) => Left(error), (response) => Right(response));
  }
}

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/user_request_account/data/data_source/data/user_request_account_data_source.dart';

import '../../domain/repositories/user_request_account_repo.dart';

@Injectable(as: UserRequestAccountRepo)
class UserRequestAccountRepoImpl implements UserRequestAccountRepo {
  UserRequestAccountDataSource userRequestAccountDataSource;
  UserRequestAccountRepoImpl({required this.userRequestAccountDataSource});

  @override
  Future<Either<Failure, void>> userRequestAccountFireStore(
      String image,
      String type,
      String userName,
      String phone,
      String email,
      String password) async {
    var either = await userRequestAccountDataSource.userRequestAccountAuth(
        image, type, userName, phone, email, password);

    return either.fold((error) => Left(error), (response) => Right(response));
  }
}

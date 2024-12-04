import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/register/domain/entities/user_model_entity.dart';
import 'package:bug_away/Features/reports/data/data_sources/get_users_data_source.dart';

import '../../domain/repositories/get_users_repo.dart';

@Injectable(as: GetUsersRepo)
class GetUsersRepoImpl implements GetUsersRepo {
  GetUsersDataSource getUsersDataSource;

  GetUsersRepoImpl({required this.getUsersDataSource});

  @override
  Future<Either<Failure, List<UserAndAdminModelEntity>>>
      getUsersFromFireStore() async {
    var either = await getUsersDataSource.getUsersFromFireStore();
    return either.fold((error) => Left(error), (users) => Right(users));
  }
}

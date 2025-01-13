import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/account_request_admin/data/data_sources/account_resuest_date_source.dart';
import 'package:bug_away/Features/account_request_admin/domain/repositories/account_request_repo.dart';
import 'package:bug_away/Features/user_request_account/domain/entities/user_request_account_model_entity.dart';

@Injectable(as: AccountRequestRepo)
class AccountRequestRepoImpl implements AccountRequestRepo {
  AccountRequestDataSource accountRequestDataSource;
  AccountRequestRepoImpl({required this.accountRequestDataSource});
  @override
  Future<Either<Failure, Stream<QuerySnapshot<UserRequestAccountEntity>>>>
      getRequests() async {
    var either = await accountRequestDataSource.getRequests();
    return either.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, void>> acceptRequests(
      UserRequestAccountEntity user) async {
    var either = await accountRequestDataSource.acceptRequests(user);
    return either.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, void>> declineRequests(
      UserRequestAccountEntity user) async {
    var either = await accountRequestDataSource.declineRequests(user);
    return either.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, void>> deleteRequests(String id) async {
    var either = await accountRequestDataSource.deleteRequests(id);
    return either.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/user_request_account/domain/entities/user_request_account_model_entity.dart';

abstract class AccountRequestDataSource {
  Future<Either<Failure, Stream<QuerySnapshot<UserRequestAccountEntity>>>>
      getRequests();
  Future<Either<Failure, void>> acceptRequests(UserRequestAccountEntity user);
  Future<Either<Failure, void>> declineRequests(UserRequestAccountEntity user);
  Future<Either<Failure, void>> deleteRequests(String id);
}

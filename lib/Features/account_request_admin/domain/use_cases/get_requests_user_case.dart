import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/account_request_admin/domain/repositories/account_request_repo.dart';
import 'package:bug_away/Features/user_request_account/domain/entities/user_request_account_model_entity.dart';

@injectable
class GetRequestsUseCase {
  AccountRequestRepo accountRequests;
  GetRequestsUseCase({required this.accountRequests});

  Future<Either<Failure, Stream<QuerySnapshot<UserRequestAccountEntity>>>>
      getRequests() {
    return accountRequests.getRequests();
  }
}

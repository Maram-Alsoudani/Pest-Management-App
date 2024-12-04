import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/account_request_admin/domain/repositories/account_request_repo.dart';

@injectable
class DeleteRequestsUseCase {
  AccountRequestRepo accountRequests;
  DeleteRequestsUseCase({required this.accountRequests});

  Future<Either<Failure, void>> deleteRequests(String id) {
    return accountRequests.deleteRequests(id);
  }
}

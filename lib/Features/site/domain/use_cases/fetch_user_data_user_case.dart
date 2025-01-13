import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Features/register/domain/entities/user_model_entity.dart';
import 'package:bug_away/Features/site/domain/repositories/site_repository.dart';

import '../../../../Core/errors/failures.dart';

@injectable
class FetchUsersDataUseCase {
  SiteRepository siteRepository;
  FetchUsersDataUseCase({required this.siteRepository});

  Future<Either<Failure, List<UserAndAdminModelEntity>>> invoke() {
    return siteRepository.fetchUserData();
  }
}

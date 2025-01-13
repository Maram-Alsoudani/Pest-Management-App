import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/reports/domain/entities/site_entity.dart';
import 'package:bug_away/Features/reports/domain/repositories/get_sites_of_user_repo.dart';

@injectable
class GetSitesOfUserUseCase {
  GetSitesOfUserRepo getSitesOfUser;

  GetSitesOfUserUseCase({required this.getSitesOfUser});

  Future<Either<Failure, List<SiteEntity>>> invoke(String userId) {
    return getSitesOfUser.getSitesOfUser(userId);
  }
}

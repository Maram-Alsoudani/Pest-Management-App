import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/reports/domain/entities/site_entity.dart';
import 'package:pesticides/Features/reports/domain/repositories/get_sites_of_user_repo.dart';

@injectable
class GetSitesOfUserUseCase {
  GetSitesOfUserRepo getSitesOfUser;

  GetSitesOfUserUseCase({required this.getSitesOfUser});

  Future<Either<Failure, List<SiteEntity>>> invoke(String userId) {
    return getSitesOfUser.getSitesOfUser(userId);
  }
}

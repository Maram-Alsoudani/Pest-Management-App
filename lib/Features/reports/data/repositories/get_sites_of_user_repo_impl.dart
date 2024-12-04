import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';

import '../../domain/entities/site_entity.dart';
import '../../domain/repositories/get_sites_of_user_repo.dart';
import '../data_sources/get_sites_of_user_data_source.dart';

@Injectable(as: GetSitesOfUserRepo)
class GetSitesOfUserRepoImpl implements GetSitesOfUserRepo {
  GetSitesOfUserDataSource getSitesOfUserDataSource;

  GetSitesOfUserRepoImpl({required this.getSitesOfUserDataSource});

  @override
  Future<Either<Failure, List<SiteEntity>>> getSitesOfUser(
      String userId) async {
    var either = await getSitesOfUserDataSource.getSitesOfUser(userId);
    return either.fold((error) => Left(error), (sites) => Right(sites));
  }
}

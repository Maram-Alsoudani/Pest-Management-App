import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/register/domain/entities/user_model_entity.dart';
import 'package:pesticides/Features/site/data/data_sources/add_site_data_source.dart';
import 'package:pesticides/Features/site/domain/repositories/site_repository.dart';

import '../../../reports/domain/entities/site_entity.dart';

@Injectable(as: SiteRepository)
class AddSiteRepositoryImpl implements SiteRepository {
  AddSiteDataSource addSiteDataSource;
  AddSiteRepositoryImpl({required this.addSiteDataSource});
  @override
  Future<Either<Failure, void>> addSite(
      String siteName, String siteLocation, String uId,String userNameSite) async {
    var either = await addSiteDataSource.addSite(siteName, siteLocation, uId,userNameSite);
    return either.fold((error) => Left(error), (response) => Right(response));
  }

  @override
  Future<Either<Failure, List<SiteEntity>>> fetchSiteData() async {
    var either = await addSiteDataSource.fetchSiteData();
    return either.fold((error) => Left(error), (response) => Right(response));
  }

  @override
  Future<Either<Failure, List<UserAndAdminModelEntity>>> fetchUserData() async {
    var either = await addSiteDataSource.fetchUserData();
    return either.fold((error) => Left(error), (response) => Right(response));
  }

  @override
  Future<Either<Failure, List<SiteEntity>>> fetchUserSites(String uId) async {
    var either = await addSiteDataSource.fetchUserSites(uId);
    return either.fold((error) => Left(error), (response) => Right(response));
  }

  @override
  Future<Either<Failure, void>> deleteSite(SiteEntity site) async {
    var either = await addSiteDataSource.deleteSite(site);
    return either.fold((error) => Left(error), (response) => Right(response));
  }
}

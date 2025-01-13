import 'package:dartz/dartz.dart';

import '../../../../Core/errors/failures.dart';
import '../../../register/domain/entities/user_model_entity.dart';
import '../../../reports/domain/entities/site_entity.dart';

abstract class AddSiteDataSource {
  Future<Either<Failure, void>> addSite(
      String siteName, String siteLocation, String uId,String userNameSite);

  Future<Either<Failure, List<SiteEntity>>> fetchSiteData();
  Future<Either<Failure, List<UserAndAdminModelEntity>>> fetchUserData();
  Future<Either<Failure, List<SiteEntity>>> fetchUserSites(String uId);
  Future<Either<Failure, void>> deleteSite(SiteEntity site);


}

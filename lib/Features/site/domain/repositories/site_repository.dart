import 'package:dartz/dartz.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/site/domain/entities/site_entitiy.dart';

import '../../../register/domain/entities/user_model_entity.dart';

abstract class SiteRepository {
  Future<Either<Failure, void>> addSite(
      String siteName, String siteLocation, String uId);

  Future<Either<Failure, List<SiteEntitiy>>> fetchSiteData();
  Future<Either<Failure, List<UserAndAdminModelEntity>>> fetchUserData();
}

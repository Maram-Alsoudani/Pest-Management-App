import 'package:dartz/dartz.dart';

import '../../../../Core/errors/failures.dart';
import '../../../register/domain/entities/user_model_entity.dart';
import '../../domain/entities/site_entitiy.dart';

abstract class AddSiteDataSource {
  Future<Either<Failure, void>> addSite(
      String siteName, String siteLocation, String uId);

  Future<Either<Failure, List<SiteEntitiy>>> fetchSiteData();
  Future<Either<Failure, List<UserAndAdminModelEntity>>> fetchUserData();

}

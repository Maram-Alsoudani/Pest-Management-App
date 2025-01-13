import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Features/site/domain/repositories/site_repository.dart';

import '../../../../Core/errors/failures.dart';

@injectable
class AddSiteUserCase {
  SiteRepository siteRepository;
  AddSiteUserCase({required this.siteRepository});

  Future<Either<Failure, void>> invoke(
      String siteName, String siteLocation, String uId, String userNameSite) {
    return siteRepository.addSite(siteName, siteLocation, uId, userNameSite);
  }
}

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Features/site/domain/repositories/site_repository.dart';

import '../../../../Core/errors/failures.dart';
import '../../../reports/domain/entities/site_entity.dart';

@injectable
class FetchSiteDataUseCase {
  SiteRepository siteRepository;
  FetchSiteDataUseCase({required this.siteRepository});

  Future<Either<Failure, List<SiteEntity>>> invoke() {
    return siteRepository.fetchSiteData();
  }
}

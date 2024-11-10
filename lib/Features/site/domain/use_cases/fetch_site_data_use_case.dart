import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Features/site/domain/repositories/site_repository.dart';

import '../../../../Core/errors/failures.dart';
import '../entities/site_entitiy.dart';

@injectable
class FetchSiteDataUseCase {
  SiteRepository siteRepository;
  FetchSiteDataUseCase({required this.siteRepository});

  Future<Either<Failure, List<SiteEntitiy>>> invoke() {
    return siteRepository.fetchSiteData();
  }
}

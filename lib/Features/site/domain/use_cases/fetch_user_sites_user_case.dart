import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Features/register/domain/entities/user_model_entity.dart';
import 'package:pesticides/Features/reports/domain/entities/site_entity.dart';
import 'package:pesticides/Features/site/domain/repositories/site_repository.dart';

import '../../../../Core/errors/failures.dart';

@injectable
class FetchUsersSitesUseCase {
  SiteRepository siteRepository;
  FetchUsersSitesUseCase({required this.siteRepository});

  Future<Either<Failure, List<SiteEntity>>> invoke(String uId) {
    return siteRepository.fetchUserSites(uId);
  }
}

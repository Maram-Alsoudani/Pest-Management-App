import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Features/register/domain/entities/user_model_entity.dart';
import 'package:pesticides/Features/reports/domain/entities/site_entity.dart';
import 'package:pesticides/Features/site/domain/repositories/site_repository.dart';

import '../../../../Core/errors/failures.dart';

@injectable
class DeleteSitesUseCase {
  SiteRepository siteRepository;
  DeleteSitesUseCase({required this.siteRepository});

  Future<Either<Failure, void>> invoke(SiteEntity site) {
    return siteRepository.deleteSite(site);
  }
}

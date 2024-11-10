import 'package:dartz/dartz.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/reports/domain/entities/site_entity.dart';

abstract class GetSitesOfUserRepo {
  Future<Either<Failure, List<SiteEntity>>> getSitesOfUser(String userId);
}

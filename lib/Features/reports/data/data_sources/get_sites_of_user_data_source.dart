import 'package:dartz/dartz.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/reports/domain/entities/site_entity.dart';

abstract class GetSitesOfUserDataSource {
  Future<Either<Failure, List<SiteEntity>>> getSitesOfUser(String userId);
}

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/reports/domain/repositories/get_report_of_site_repo.dart';
import 'package:bug_away/Features/site_report/domain/entities/report_entity.dart';

@injectable
class GetReportOfSiteUseCase {
  GetReportOfSiteRepo getReportOfSiteRepo;

  GetReportOfSiteUseCase({required this.getReportOfSiteRepo});

  Future<Either<Failure, ReportEntity>> invoke(String siteId) {
    return getReportOfSiteRepo.getReportOfSite(siteId);
  }
}

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/reports/domain/repositories/get_report_of_site_repo.dart';
import 'package:pesticides/Features/site_report/domain/entities/report_entity.dart';

@injectable
class GetReportOfSiteUseCase {
  GetReportOfSiteRepo getReportOfSiteRepo;

  GetReportOfSiteUseCase({required this.getReportOfSiteRepo});

  Future<Either<Failure, ReportEntity>> invoke(String siteId) {
    return getReportOfSiteRepo.getReportOfSite(siteId);
  }
}

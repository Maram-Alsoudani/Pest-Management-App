import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/reports/data/data_sources/get_report_of_site_data_source.dart';
import 'package:bug_away/Features/reports/domain/repositories/get_report_of_site_repo.dart';
import 'package:bug_away/Features/site_report/domain/entities/report_entity.dart';

@Injectable(as: GetReportOfSiteRepo)
class GetReportOfSiteRepoImpl implements GetReportOfSiteRepo {
  GetReportOfSiteDataSource getReportOfSiteDataSource;

  GetReportOfSiteRepoImpl({required this.getReportOfSiteDataSource});

  @override
  Future<Either<Failure, ReportEntity>> getReportOfSite(String siteId) async {
    var either = await getReportOfSiteDataSource.getReportOfSite(siteId);
    return either.fold((error) => Left(error), (report) => Right(report));
  }
}

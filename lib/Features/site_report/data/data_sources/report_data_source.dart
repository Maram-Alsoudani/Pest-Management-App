import 'package:dartz/dartz.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/site_report/data/models/report_dto.dart';

abstract class ReportDataSource {
  Future<Either<Failure, void>> createReport(ReportModel report);
  Future<Either<Failure, List<ReportModel>>> fetchReports(String userId);
}

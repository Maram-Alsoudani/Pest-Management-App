import 'package:dartz/dartz.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/site_report/data/models/report_dto.dart';

abstract class ReportDataSource {
  Future<Either<Failure, void>> createReport(ReportModel report);
  Future<Either<Failure, List<ReportModel>>> fetchReports(String userId);
}

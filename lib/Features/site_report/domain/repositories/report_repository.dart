import 'package:dartz/dartz.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/site_report/domain/entities/report_entity.dart';

abstract class ReportRepository {
  Future<Either<Failure, void>> createReport(ReportEntity report);
  Future<Either<Failure, List<ReportEntity>>> fetchReports(String userId);
}

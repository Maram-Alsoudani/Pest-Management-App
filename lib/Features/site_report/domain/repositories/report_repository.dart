import 'package:dartz/dartz.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/site_report/domain/entities/report_entity.dart';

abstract class ReportRepository {
  Future<Either<Failure, void>> createReport(ReportEntity report);
  Future<Either<Failure, List<ReportEntity>>> fetchReports(String userId);
}

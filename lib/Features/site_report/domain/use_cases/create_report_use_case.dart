import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/site_report/domain/entities/report_entity.dart';
import 'package:pesticides/Features/site_report/domain/repositories/report_repository.dart';

@injectable
class CreateReportUseCase {
  final ReportRepository repository;

  CreateReportUseCase(this.repository);

  Future<Either<Failure, void>> call(ReportEntity report) async {
    return await repository.createReport(report);
  }
}

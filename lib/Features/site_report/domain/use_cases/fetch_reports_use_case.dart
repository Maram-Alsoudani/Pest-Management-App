import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/site_report/domain/entities/report_entity.dart';
import 'package:pesticides/Features/site_report/domain/repositories/report_repository.dart';

@injectable
class FetchReportsUseCase {
  final ReportRepository repository;

  FetchReportsUseCase(this.repository);

  Future<Either<Failure, List<ReportEntity>>> call(String userId) async {
    return await repository.fetchReports(userId);
  }
}

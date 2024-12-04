import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/site_report/data/models/report_dto.dart';
import '../../domain/entities/report_entity.dart';
import '../../domain/repositories/report_repository.dart';
import '../data_sources/report_data_source.dart';

@Injectable(as: ReportRepository)
class ReportRepositoryImpl implements ReportRepository {
  final ReportDataSource dataSource;

  ReportRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, void>> createReport(ReportEntity report) async {
    return await dataSource.createReport(ReportModel(
      id: report.id,
      siteId: report.siteId,
      siteName: report.siteName.isNotEmpty ? report.siteName : 'Unknown',
      notes: report.notes.isNotEmpty ? report.notes : 'No notes',
      conditions:
          report.conditions.isNotEmpty ? report.conditions : 'No conditions',
      recommendations: report.recommendations.isNotEmpty
          ? report.recommendations
          : ['No recommendations'],
      materialUsages: report.materialUsages.isNotEmpty
          ? report.materialUsages
          : {'No material usages': 0},
      photos: report.photos.isNotEmpty ? report.photos : ['No photos'],
      devices: report.devices.isNotEmpty ? report.devices : ['No devices'],
      signatures:
          report.signatures.isNotEmpty ? report.signatures : ['No signatures'],
      userId: report.userId,
      createdBy: report.createdBy,
      createdAt: report.createdAt,
    ));
  }

  @override
  Future<Either<Failure, List<ReportEntity>>> fetchReports(
      String userId) async {
    final result = await dataSource.fetchReports(userId);
    return result.fold(
      (failure) => Left(failure),
      (reports) => Right(reports
          .map((report) => ReportEntity(
                id: report.id,
                siteName: report.siteName,
                siteId: report.siteId,
                notes: report.notes,
                conditions: report.conditions,
                recommendations: report.recommendations,
                materialUsages: report.materialUsages,
                photos: report.photos,
                devices: report.devices,
                signatures: report.signatures,
                userId: report.userId,
                createdBy: report.createdBy,
                createdAt: report.createdAt,
              ))
          .toList()),
    );
  }
}

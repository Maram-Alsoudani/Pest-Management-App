import 'package:dartz/dartz.dart';

import '../../../../Core/errors/failures.dart';
import '../../../site_report/domain/entities/report_entity.dart';

abstract class GetReportOfSiteRepo {
  Future<Either<Failure, ReportEntity>> getReportOfSite(String siteId);
}

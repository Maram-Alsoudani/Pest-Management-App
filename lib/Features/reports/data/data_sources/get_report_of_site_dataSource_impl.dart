import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/site_report/data/models/report_dto.dart';
import 'package:bug_away/Features/site_report/domain/entities/report_entity.dart';

import 'get_report_of_site_data_source.dart';

@Injectable(as: GetReportOfSiteDataSource)
class GetReportOfSiteDataSourceImpl implements GetReportOfSiteDataSource {
  @override
  Future<Either<Failure, ReportEntity>> getReportOfSite(String siteId) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      try {
        final querySnapshot = await FirebaseFirestore.instance
            .collection('reports')
            .where('siteId', isEqualTo: siteId)
            .get();

        if (querySnapshot.docs.isEmpty) {
          return Left(Failure(errorMessage: StringManager.noReportFound));
        }

        final reportData = querySnapshot.docs.first.data();

        final reportModel = ReportModel.fromJson(reportData);
        return Right(reportModel);
      } catch (e) {
        return Left(Failure(errorMessage: e.toString()));
      }
    } else {
      return Left(Failure(errorMessage: StringManager.networkError));
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/site_report/data/models/report_dto.dart';
import 'report_data_source.dart';

@Injectable(as: ReportDataSource)
class ReportDataSourceImpl implements ReportDataSource {
  @override
  Future<Either<Failure, void>> createReport(ReportModel report) async {
    try {
      var reportCollection = FirebaseFirestore.instance
          .collection('reports'); // Independent collection
      var reportDocRef = reportCollection.doc();
      report.id = reportDocRef.id;
      await reportDocRef.set(report.toJson());
      return const Right(null);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReportModel>>> fetchReports(String userId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('reports')
          .where('userId', isEqualTo: userId)
          .get();
      var reports = querySnapshot.docs.map((doc) {
        return ReportModel.fromJson(doc.data());
      }).toList();
      return Right(reports);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}

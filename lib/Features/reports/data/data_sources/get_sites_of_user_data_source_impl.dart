import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/reports/data/data_sources/get_sites_of_user_data_source.dart';
import 'package:bug_away/Features/reports/data/models/site_dto.dart';
import 'package:bug_away/Features/reports/domain/entities/site_entity.dart';

import '../../../../Core/errors/failures.dart';

@Injectable(as: GetSitesOfUserDataSource)
class GetSitesOfUserDataSourceImpl implements GetSitesOfUserDataSource {
  @override
  Future<Either<Failure, List<SiteDto>>> getSitesOfUser(String userId) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      try {
        // get user collection then user doc
        DocumentReference<Map<String, dynamic>> userDoc =
            FirebaseFirestore.instance.collection('user').doc(userId);

        //get sites docs of user (sites collection of user doc)
        var siteSnapshot =
            await userDoc.collection(SiteEntity.collectionName).get();

        //converting it to list of sites
        if (siteSnapshot.docs.isNotEmpty) {
          var sites = siteSnapshot.docs.map((doc) {
            final data = doc.data();
            return SiteDto(
              siteId: data["siteId"] ?? "",
              siteLocation: data['siteLocation'] ?? "",
              siteName: data['siteName'] ?? "",
            );
          }).toList();
          return Right(sites);
        } else {
          return Left(Failure(errorMessage: StringManager.noSitesFound));
        }
      } catch (e) {
        return Left(Failure(errorMessage: e.toString()));
      }
    } else {
      return Left(Failure(errorMessage: "Internet Connection is lost."));
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Core/utils/firebase_utils.dart';
import 'package:pesticides/Features/register/domain/entities/user_model_entity.dart';
import 'package:pesticides/Features/site/data/data_sources/add_site_data_source.dart';
import 'package:pesticides/Features/site/data/models/siteDTO.dart';
import 'package:pesticides/Features/site/domain/entities/site_entitiy.dart';

import '../../../../Core/utils/strings.dart';
import '../../../register/data/models/user_model_dto.dart';

@Injectable(as: AddSiteDataSource)
class AddSiteDataSourceImpl implements AddSiteDataSource {
  @override
  Future<Either<Failure, void>> addSite(
      String siteName, String siteLocation, String uId) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      var site = SitedDTO(siteName: siteName, siteLocation: siteLocation);
      try {
        var response =
            await FirebaseUtils.addSiteToUsersFireStore(site: site, uId: uId);
        return Right(null);
      } on FirebaseException catch (e) {
        return Left(Failure(errorMessage: e.toString()));
      } catch (e) {
        return Left(Failure(errorMessage: e.toString()));
      }
    } else {
      return Left(NetworkFailure(errorMessage: StringManager.networkError));
    }
  }

  @override
  Future<Either<Failure, List<SitedDTO>>> fetchSiteData() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      try {
        //todo response is a List of sites
        var response = await FirebaseUtils.fetchAllSitesAcrossAllUsers();
        return Right(response);
      } on FirebaseException catch (e) {
        return Left(Failure(errorMessage: e.toString()));
      } catch (e) {
        return Left(Failure(errorMessage: e.toString()));
      }
    } else {
      return Left(NetworkFailure(errorMessage: StringManager.networkError));
    }
  }

  @override
  Future<Either<Failure, List<UserAndAdminModelEntity>>> fetchUserData() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      try {
        //todo response is a List of sites
        var response = await FirebaseUtils.readUserFromFireStore();
        return Right(response);
      } on FirebaseException catch (e) {
        return Left(Failure(errorMessage: e.toString()));
      } catch (e) {
        return Left(Failure(errorMessage: e.toString()));
      }
    } else {
      return Left(NetworkFailure(errorMessage: StringManager.networkError));
    }
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Config/routes/routes_manger.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Core/utils/SharedPrefsLocal.dart';
import 'package:bug_away/Core/utils/fcm_helper.dart';
import 'package:bug_away/Core/utils/firebase_utils.dart';
import 'package:bug_away/Core/utils/notification_model.dart';
import 'package:bug_away/Features/register/domain/entities/user_model_entity.dart';
import 'package:bug_away/Features/reports/domain/entities/site_entity.dart';
import 'package:bug_away/Features/site/data/data_sources/add_site_data_source.dart';

import '../../../../Core/utils/strings.dart';
import '../../../register/data/models/user_model_dto.dart';
import '../../../reports/data/models/site_dto.dart';

@Injectable(as: AddSiteDataSource)
class AddSiteDataSourceImpl implements AddSiteDataSource {
  Future<void> handleNotification(
      UserAndAdminModelDto adminData, userAddForHimSite) async {
    String title = "Sites Added Action";
    String body =
        "Admin (${adminData.userName ?? ""}) is Added New Site To ($userAddForHimSite)";

    List<UserAndAdminModelDto> adminList =
        await FirebaseUtils.getAdminOrUserTokenFromFireStore(
            UserAndAdminModelDto.admin);
    List<UserAndAdminModelDto> userList =
        await FirebaseUtils.getAdminOrUserTokenFromFireStore(
            UserAndAdminModelDto.user);

    NotificationModel notificationModel = NotificationModel(
        route: RoutesManger.routeNameSites,
        title: title,
        body: body,
        dateTime: DateTime.now(),
        to: "All");

    for (var admin in adminList) {
      if (admin.email == adminData.email) {
        continue;
      }
      if (admin.fcmToken != null) {
        var tokens = admin.fcmToken;
        for (var token in tokens!) {
          await NotificationService.sendNotification(token, title, body);
        }
      }
      await FirebaseUtils.saveNotification(
          notificationModel, UserAndAdminModelDto.admin, admin.id!);
    }

    for (var user in userList) {
      if (user.email == adminData.email) {
        continue;
      }
      if (user.fcmToken != null) {
        var tokens = user.fcmToken;
        for (var token in tokens!) {
          await NotificationService.sendNotification(token, title, body);
        }
      }
      await FirebaseUtils.saveNotification(
          notificationModel, UserAndAdminModelDto.user, user.id!);
    }
  }

  @override
  Future<Either<Failure, void>> addSite(String siteName, String siteLocation,
      String uId, String userNameSite) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      var site =
          SiteDto(siteName: siteName, siteLocation: siteLocation, userId: uId);
      try {
        var response =
            await FirebaseUtils.addSiteToUsersFireStore(site: site, uId: uId);

        if (Platform.isAndroid) {
          var data = SharedPrefsLocal.getData(key: StringManager.userAdmin);
          await handleNotification(data!, userNameSite);
        }
        return const Right(null);
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
  Future<Either<Failure, List<SiteDto>>> fetchSiteData() async {
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

  @override
  Future<Either<Failure, List<SiteEntity>>> fetchUserSites(String uId) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      try {
        //todo response is a List of sites
        var response = await FirebaseUtils.getUserSite(uId);
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
  Future<Either<Failure, void>> deleteSite(SiteEntity site) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      try {
        //todo response is a List of sites
        var response = await FirebaseUtils.deleteSites(site as SiteDto);
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

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
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/inventory/data/data_sources/inventory_data_source.dart';
import 'package:bug_away/Features/inventory/data/models/materail_model_dto.dart';
import 'package:bug_away/Features/register/data/models/user_model_dto.dart';

import '../../../domain/entities/materail_enitiy.dart';

@Injectable(as: InventoryDataSource)
class InventoryDataSourceImpl implements InventoryDataSource {
  Future<void> addMaterailsFireStore(MaterailModelDto materails) {
    var taskCollection = FirebaseUtils.getMaterailCollection();
    DocumentReference<MaterailModelDto> taskDoc = taskCollection.doc();
    materails.id = taskDoc.id;
    return taskDoc.set(materails);
  }

  Future<void> editMaterail(MaterailModelDto materails) async {
    var taskCollection = FirebaseUtils.getMaterailCollection();
    return taskCollection.doc(materails.id).update({
      'name': materails.name,
      'quantity': materails.quantity,
      'unit': materails.unit
    });
  }

  Future<void> deleteMaterailsFireStore(String id) {
    return FirebaseUtils.getMaterailCollection().doc(id).delete();
  }

  Future<void> handleNotification(UserAndAdminModelDto adminData) async {
    String title = "Materail Added Action";
    String body = "Admin (${adminData.userName ?? ""}) is Added New Materail";

    List<UserAndAdminModelDto> adminList =
        await FirebaseUtils.getAdminOrUserTokenFromFireStore(
            UserAndAdminModelDto.admin);
    List<UserAndAdminModelDto> userList =
        await FirebaseUtils.getAdminOrUserTokenFromFireStore(
            UserAndAdminModelDto.user);

    NotificationModel notificationModel = NotificationModel(
        route: RoutesManger.routeNameInventory,
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
  Future<Either<Failure, void>> addedMaterail(MaterailEntity materail) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        MaterailModelDto materails = MaterailModelDto(
            name: materail.name,
            quantity: materail.quantity,
            unit: materail.unit);
        await addMaterailsFireStore(materails);
        if (Platform.isAndroid) {
          var admin = SharedPrefsLocal.getData(key: StringManager.userAdmin);
          await handleNotification(admin!);
        }
        return const Right(null);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      return Left(Failure(errorMessage: StringManager.somethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMaterail(String id) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        await deleteMaterailsFireStore(id);
        return const Right(null);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      print(e);
      return Left(Failure(errorMessage: StringManager.somethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, List<MaterailModelDto>>> fetchMaterialsList() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        var docSnapshot = await FirebaseUtils.getMaterailCollection().get();
        var data = docSnapshot.docs;
        List<MaterailModelDto> list = data.map((e) => e.data()).toList();
        return Right(list);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      return Left(Failure(errorMessage: StringManager.somethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, void>> updateMaterail(
      String id, String name, int quantity, String unit) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        MaterailModelDto materails = MaterailModelDto(
            id: id, name: name, quantity: quantity, unit: unit);
        await editMaterail(materails);
        return const Right(null);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      return Left(Failure(errorMessage: StringManager.somethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, void>> incrementQuantity(
      String id, int quantity) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        var taskCollection = FirebaseUtils.getMaterailCollection();
        await taskCollection.doc(id).update({'quantity': quantity});
        return const Right(null);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      return Left(Failure(errorMessage: StringManager.somethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, void>> decrementQuantity(
      String id, int quantity) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        var taskCollection = FirebaseUtils.getMaterailCollection();
        await taskCollection.doc(id).update({'quantity': quantity});
        return const Right(null);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      return Left(Failure(errorMessage: StringManager.somethingWentWrong));
    }
  }
}

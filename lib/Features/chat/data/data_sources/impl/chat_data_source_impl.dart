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
import 'package:bug_away/Features/chat/data/data_sources/chat_data_source.dart';
import 'package:bug_away/Features/chat/data/models/message_dto.dart';
import 'package:bug_away/Features/register/data/models/user_model_dto.dart';

@Injectable(as: ChatDataSource)
class ChatDataSourceImpl implements ChatDataSource {
  @override
  Future<Either<Failure, Stream<QuerySnapshot<MessageDto>>>>
      getMessage() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        Stream<QuerySnapshot<MessageDto>> streamMessage =
            FirebaseUtils.getMessageFromFireStore();

        return Right(streamMessage);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      return Left(Failure(errorMessage: StringManager.errorOccurred));
    }
  }

  Future<void> handleNotification(
      UserAndAdminModelDto adminData, String bodyMessage) async {
    String title = adminData.userName ?? "";
    String body = bodyMessage;

    List<UserAndAdminModelDto> adminList =
        await FirebaseUtils.getAdminOrUserTokenFromFireStore(
            UserAndAdminModelDto.admin);
    List<UserAndAdminModelDto> userList =
        await FirebaseUtils.getAdminOrUserTokenFromFireStore(
            UserAndAdminModelDto.user);

    NotificationModel notificationModel = NotificationModel(
        route: RoutesManger.routeNameChat,
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
  Future<Either<Failure, void>> sendMessage(MessageDto message) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        var result = await FirebaseUtils.insertMessage(message);
        if (Platform.isAndroid) {
          var data = SharedPrefsLocal.getData(key: StringManager.userAdmin);
          await handleNotification(data!, message.content);
        }

        return const Right(null);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      return Left(Failure(errorMessage: StringManager.errorOccurred));
    }
  }
}

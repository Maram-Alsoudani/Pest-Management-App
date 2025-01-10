import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Config/routes/routes_manger.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Core/utils/fcm_helper.dart';
import 'package:bug_away/Core/utils/firebase_utils.dart';
import 'package:bug_away/Core/utils/SharedPrefsLocal.dart';
import 'package:bug_away/Core/utils/notification_model.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/register/data/models/user_model_dto.dart';
import 'data/register_data_source.dart';

@Injectable(as: RegisterDataSource)
class RegisterDataSourceImpl implements RegisterDataSource {
  static Future<void> addUserFireStore(UserAndAdminModelDto user) {
    return FirebaseUtils.getUserCollection(user.type ?? "")
        .doc(user.id)
        .set(user);
  }

  Future<void> handleNotification(
      UserAndAdminModelDto adminData, String userAdded) async {
    String title = "Add New Account";
    String body =
        "Admin (${adminData.userName ?? ""}) is Added New Account To ($userAdded)";

    List<UserAndAdminModelDto> adminList =
        await FirebaseUtils.getAdminOrUserTokenFromFireStore(
            UserAndAdminModelDto.admin);

    NotificationModel notificationModel = NotificationModel(
        route: RoutesManger.routeNameChat,
        title: title,
        body: body,
        dateTime: DateTime.now(),
        to: "admin");

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
  }

  @override
  Future<Either<Failure, void>> registerAuth(
    String? imagePath,
    String type,
    String userName,
    String phone,
    String email,
    String password,
  ) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String imageUrl = "";

      if (imagePath != null && imagePath.isNotEmpty) {
        final result =
            await FirebaseUtils.addImageToFirebaseStorage(File(imagePath));
        result.fold(
          (_) {},
          (url) => imageUrl = url,
        );
      }

      UserAndAdminModelDto userAndAdminModelDto = UserAndAdminModelDto(
          id: credential.user?.uid ?? "",
          image: imageUrl,
          type: type,
          userName: userName,
          phone: phone,
          email: email);
      await addUserFireStore(userAndAdminModelDto);
      if (Platform.isAndroid) {
        var data = SharedPrefsLocal.getData(key: StringManager.userAdmin);
        await handleNotification(data!, userName);
      }

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return Left(Failure(errorMessage: StringManager.badFormat));
      } else if (e.code == 'email-already-in-use') {
        return Left(Failure(errorMessage: StringManager.emailInUse));
      } else if (e.code == 'network-request-failed') {
        return Left(Failure(errorMessage: StringManager.networkError));
      } else {
        return Left(Failure(errorMessage: StringManager.somethingWentWrong));
      }
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:bug_away/Config/routes/routes_manger.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Core/utils/SharedPrefsLocal.dart';
import 'package:bug_away/Core/utils/fcm_helper.dart';
import 'package:bug_away/Core/utils/firebase_utils.dart';
import 'package:bug_away/Core/utils/notification_model.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/account_request_admin/data/data_sources/account_resuest_date_source.dart';
import 'package:bug_away/Features/register/data/models/user_model_dto.dart';
import 'package:bug_away/Features/user_request_account/data/models/user_request_account_model_dto.dart';
import 'package:bug_away/Features/user_request_account/domain/entities/user_request_account_model_entity.dart';

@Injectable(as: AccountRequestDataSource)
class AccountRequestDataSourceImpl implements AccountRequestDataSource {
  @override
  Future<Either<Failure, Stream<QuerySnapshot<UserRequestAccountDto>>>>
      getRequests() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        Stream<QuerySnapshot<UserRequestAccountDto>> streamMessage =
            FirebaseUtils.getRequestFromFireStore();

        return Right(streamMessage);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      return Left(Failure(errorMessage: StringManager.somethingWentWrong));
    }
  }

  static Future<void> addUserFireStore(UserAndAdminModelDto user) {
    return FirebaseUtils.getUserCollection(user.type ?? "")
        .doc(user.id)
        .set(user);
  }

  Future<void> editRequest(String status, String userId) async {
    var taskCollection = FirebaseUtils.getUserRequestAccountCollection(
        UserRequestAccountDto.requests);
    return taskCollection.doc(userId).update({
      'status': status,
    });
  }

  Future<void> deleteRequestFireStore(String id) {
    return FirebaseUtils.getUserRequestAccountCollection(
            UserRequestAccountDto.requests)
        .doc(id)
        .delete();
  }

  Future<String> sendEmail(String email, String subject, String body) async {
    const username = 'hhhmohamed91@gmail.com';
    const password = 'lcqs adlk qstk fxrz';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = const Address(username)
      ..recipients.add(email)
      ..subject = subject
      ..text = body;
    try {
      await send(message, smtpServer);
      return 'Email sent successfully!';
    } on MailerException catch (e) {
      final errorMessages = e.problems.map((problem) => problem.msg).join(', ');
      return 'Failed to send email: $errorMessages';
    } catch (e) {
      return 'An unexpected error occurred: ${e.toString()}';
    }
  }

  @override
  Future<Either<Failure, void>> acceptRequests(
      UserRequestAccountEntity user) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: user.email!.trim(),
          password: user.password!.trim(),
        );

        UserAndAdminModelDto userAndAdminModelDto = UserAndAdminModelDto(
            id: credential.user?.uid ?? "",
            image: user.image,
            type: user.type,
            userName: user.userName,
            phone: user.phone,
            email: user.email);
        user.status = "Accepted";
        await editRequest(user.status ?? "", user.id ?? "");
        var userFireStore = await addUserFireStore(userAndAdminModelDto);
        var adminData = SharedPrefsLocal.getData(key: StringManager.userAdmin);

        await sendEmail(
            user.email ?? "",
            "Pest Control Company Accepted Your Account Request ",
            "Welcome ${user.userName} In Company (${adminData!.userName ?? ""})");

        await handleNotification(adminData, user, "Accepted");
        return const Right(null);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return Left(
            Failure(errorMessage: StringManager.inspectionBaitCondition));
      } else if (e.code == 'email-already-in-use') {
        return Left(Failure(errorMessage: StringManager.emailInUse));
      } else if (e.code == 'network-request-failed') {
        return Left(Failure(errorMessage: StringManager.networkError));
      } else {
        return Left(Failure(errorMessage: StringManager.somethingWentWrong));
      }
    } catch (e) {
      return Left(Failure(errorMessage: StringManager.somethingWentWrong));
    }
  }

  Future<void> handleNotification(UserAndAdminModelDto adminData,
      UserRequestAccountEntity user, String status) async {
    String title = "Request Account Action";
    String body =
        "Admin (${adminData.userName ?? ""}) is $status Account Request to (${user.userName})";
    List<UserAndAdminModelDto> adminList =
        await FirebaseUtils.getAdminOrUserTokenFromFireStore(
            UserAndAdminModelDto.admin);
    NotificationModel notificationModel = NotificationModel(
        route: RoutesManger.routeNameRequiest,
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
  Future<Either<Failure, void>> declineRequests(
      UserRequestAccountEntity user) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        user.status = "Rejected";
        await editRequest(user.status ?? "", user.id ?? "");
        var adminData = SharedPrefsLocal.getData(key: StringManager.userAdmin);
        await sendEmail(
            user.email ?? "",
            "Pest Control Company Rejected Your Account Request ",
            "Sorry ${user.userName} Rejected Your Account \nManager:(${adminData!.userName ?? ""})");

        await handleNotification(adminData, user, "Rejected");

        return const Right(null);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
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
      print(e.toString());
      return Left(Failure(errorMessage: StringManager.somethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRequests(String id) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        await deleteRequestFireStore(id);
        return const Right(null);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
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
      return Left(Failure(errorMessage: StringManager.somethingWentWrong));
    }
  }
}

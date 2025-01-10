import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Core/utils/FCM.dart';
import 'package:bug_away/Core/utils/firebase_utils.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/login/data/data_sources/login_data_source.dart';
import 'package:bug_away/Features/register/data/models/user_model_dto.dart';

import '../../../../Core/utils/SharedPrefsLocal.dart';

@Injectable(as: LoginDataSource)
class LoginDataSourceImpl implements LoginDataSource {
  Future<void> editUserOrAdmin(
      List<String> fcmTokens, String userId, String type) async {
    var taskCollection = FirebaseUtils.getUserCollection(type);

    var userDoc = await taskCollection.doc(userId).get();

    List<dynamic> existingTokens = userDoc.data()?.fcmToken ?? [];

    existingTokens = existingTokens.toSet().toList();

    existingTokens.addAll(fcmTokens);

    existingTokens = existingTokens.toSet().toList();

    if (existingTokens.length > 4) {
      existingTokens = existingTokens.sublist(existingTokens.length - 4);
    }

    await taskCollection.doc(userId).update({
      'fcmToken': existingTokens,
    });
  }

  @override
  Future<Either<Failure, UserAndAdminModelDto?>> login(
      String email, String password, String? type) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      try {
        var collection = FirebaseFirestore.instance.collection(type ?? '');
        var querySnapshot =
            await collection.where('email', isEqualTo: email).get();

        if (querySnapshot.docs.isEmpty) {
          return Left(Failure(errorMessage: StringManager.userNotFound));
        }

        var userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (Platform.isAndroid) {
          var fcmToken = await FCM.getToken();
          if (fcmToken == null) {
            return Left(
                Failure(errorMessage: StringManager.tokenRetrieveFailed));
          }

          // get the current tokens
          var userDoc = await collection.doc(userCredential.user!.uid).get();
          List<dynamic> existingTokens = userDoc.data()?['fcmToken'] ?? [];

          // check the devices number
          if (existingTokens.length >= 4 &&
              !existingTokens.contains(fcmToken)) {
            return Left(Failure(errorMessage: StringManager.cannotLogin));
          }

          // update the FCM token
          await editUserOrAdmin(
              [fcmToken], userCredential.user!.uid, type ?? "");
        }

        if (userCredential.user != null) {
          var userData = querySnapshot.docs.first.data();
          var user = UserAndAdminModelDto.fromFireStore(userData);

          if (Platform.isAndroid) {
            // add updated tokens to the user
            user.fcmToken = await FirebaseFirestore.instance
                .collection(type ?? '')
                .doc(userCredential.user!.uid)
                .get()
                .then(
                    (doc) => List<String>.from(doc.data()?['fcmToken'] ?? []));
          }

          SharedPrefsLocal.saveData(key: StringManager.userAdmin, model: user);

          return Right(user);
        } else {
          return Left(Failure(errorMessage: StringManager.loginFailed));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == StringManager.invalidCredential) {
          return Left(Failure(errorMessage: StringManager.wrongPassword));
        } else {
          return Left(Failure(errorMessage: "${e.message}"));
        }
      } catch (e) {
        return Left(Failure(errorMessage: " ${e.toString()}"));
      }
    } else {
      return Left(Failure(errorMessage: StringManager.networkError));
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Core/utils/FCM.dart';

import 'package:pesticides/Core/utils/firebase_utils.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/login/data/data_sources/login_data_source.dart';
import 'package:pesticides/Features/register/data/models/user_model_dto.dart';

import '../../../../Core/utils/SharedPrefsLocal.dart';

@Injectable(as: LoginDataSource)
class LoginDataSourceImpl implements LoginDataSource {
  Future<void> editUserOrAdmin(String fcmToken, String userId,String type) async {
    var taskCollection = FirebaseUtils.getUserCollection(type);
    return taskCollection.doc(userId).update({
      'fcmToken': fcmToken,
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
        var fcmToken=await FCM.getToken();
        await editUserOrAdmin(fcmToken??"",userCredential.user!.uid,type??"");
        if (userCredential.user != null) {
          var userData = querySnapshot.docs.first.data();
          var user = UserAndAdminModelDto.fromFireStore(userData);
          user.fcmToken=fcmToken;
          SharedPrefsLocal.saveData(
              key: StringManager.keyUserAdmin, model: user);



          return Right(user);
        } else {
          return Left(Failure(errorMessage: StringManager.failedToLogin));
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

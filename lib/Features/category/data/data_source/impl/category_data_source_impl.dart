import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/utils/SharedPrefsLocal.dart';
import 'package:bug_away/Core/utils/firebase_utils.dart';
import 'package:bug_away/Features/register/domain/entities/user_model_entity.dart';

import '../../../../../Core/errors/failures.dart';
import '../../../../../core/utils/strings.dart';
import '../../../../register/data/models/user_model_dto.dart';
import '../category_data_source.dart';

@Injectable(as: CategoryDataSource)
class CategoryDataSourceImpl implements CategoryDataSource {
  @override
  Future<Either<Failure, UserAndAdminModelDto>>
      readUserOrAdminFromFireStore() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        var user = SharedPrefsLocal.getData(key: StringManager.userAdmin);
        if (user != null) {
          var dataUser = await FirebaseUtils.getUserCollection(user.type ?? "")
              .doc(user.id)
              .get();
          return Right(dataUser.data()!);
        } else {
          return Left(Failure(errorMessage: StringManager.somethingWentWrong));
        }
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      print(e.toString());
      return Left(Failure(errorMessage: StringManager.somethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, void>> editUserData(
      UserAndAdminModelEntity user) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        var userLocal = SharedPrefsLocal.getData(key: StringManager.userAdmin);

        var dataUser = await FirebaseUtils.getUserCollection(user.type ?? "")
            .doc(userLocal!.id)
            .update({
          "image": user.image,
          "userName": user.userName,
          "phone": user.phone,
          "email": user.email,
        });
        return const Right(null);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      print(e.toString());
      return Left(Failure(errorMessage: StringManager.somethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, void>> editImage(String? image) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        var user = SharedPrefsLocal.getData(key: StringManager.userAdmin);
        var dataUserCollection =
            await FirebaseUtils.getUserCollection(user?.type ?? "")
                .doc(user!.id)
                .get();

        String currentImageUrl = dataUserCollection.data()?.image ?? "";

        // Delete the existing image if it exists
        if (currentImageUrl.isNotEmpty) {
          try {
            final ref = FirebaseStorage.instance.refFromURL(currentImageUrl);
            await ref.delete();
          } catch (error) {
            if (error.toString().contains('object-not-found')) {
            } else {
              rethrow;
            }
          }
        }

        // Proceed to upload the new image
        String imageUrl = "";
        var userLocal = SharedPrefsLocal.getData(key: StringManager.userAdmin);
        final result =
            await FirebaseUtils.addImageToFirebaseStorage(File(image!));
        result.fold(
          (_) {},
          (url) => imageUrl = url,
        );

        await FirebaseUtils.getUserCollection(userLocal?.type ?? "")
            .doc(userLocal!.id)
            .update({
          "image": imageUrl,
        });

        return const Right(null);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      return Left(Failure(errorMessage: StringManager.somethingWentWrong));
    }
  }

  @override
  Future<Either<Failure, void>> removeFcm() async {
    if (!Platform.isAndroid) {
      return const Right(null);
    }

    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        var user = SharedPrefsLocal.getData(key: StringManager.userAdmin);

        await FirebaseUtils.getUserCollection(user?.type ?? "")
            .doc(user?.id ?? "")
            .update({
          "fcmToken": FieldValue.arrayRemove([user!.fcmToken![0]]),
        });

        return const Right(null);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      print(e.toString());
      return Left(Failure(errorMessage: StringManager.somethingWentWrong));
    }
  }
}

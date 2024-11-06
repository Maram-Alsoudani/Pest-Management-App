import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/utils/SharedPrefsLocal.dart';
import 'package:pesticides/Core/utils/firebase_utils.dart';
import 'package:pesticides/Features/register/domain/entities/user_model_entity.dart';

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
        var user = SharedPrefsLocal.getData(key: StringManager.keyUserAdmin);
        if (user != null) {
          var dataUser = await FirebaseUtils.getUserCollection(user.type ?? "")
              .doc(user.id)
              .get();
          return Right(dataUser.data()!);
        } else {
          return Left(Failure(
              errorMessage: "User data not found in SharedPreferences"));
        }
      } else {
        return Left(Failure(errorMessage: "No internet connection"));
      }
    } catch (e) {
      print(e.toString());
      return Left(Failure(errorMessage: "An error occurred: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> editUserData(
      UserAndAdminModelEntity user) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        var userLocal =
            SharedPrefsLocal.getData(key: StringManager.keyUserAdmin);

        var dataUser = await FirebaseUtils.getUserCollection(user.type ?? "")
            .doc(userLocal!.id)
            .update({
          "image": user.image,
          "userName": user.userName,
          "phone": user.phone,
          "email": user.email,
        });
        return Right(null);
      } else {
        return Left(Failure(errorMessage: "No internet connection"));
      }
    } catch (e) {
      print(e.toString());
      return Left(Failure(errorMessage: "An error occurred: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> editImage(String? image) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        var user = SharedPrefsLocal.getData(key: StringManager.keyUserAdmin);
        var dataUserCollection = await FirebaseUtils.getUserCollection(user?.type ?? "")
            .doc(user!.id)
            .get();

        String currentImageUrl = dataUserCollection.data()?.image ?? "";
        if (currentImageUrl.isNotEmpty) {
          final ref = FirebaseStorage.instance.refFromURL(currentImageUrl);
          await ref.delete();
        }

        String imageUrl = "";
        var userLocal = SharedPrefsLocal.getData(key: StringManager.keyUserAdmin);
        final result = await FirebaseUtils.addImageToFirebaseStorage(File(image!));
        result.fold(
              (_) {},
              (url) => imageUrl = url,
        );

        await FirebaseUtils.getUserCollection(userLocal?.type ?? "")
            .doc(userLocal!.id)
            .update({
          "image": imageUrl,
        });

        return Right(null);
      } else {
        return Left(Failure(errorMessage: "No internet connection"));
      }
    } catch (e) {
      print(e.toString());
      return Left(Failure(errorMessage: "An error occurred: $e"));
    }
  }

}

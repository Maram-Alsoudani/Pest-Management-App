import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Core/utils/firebase_utils.dart';
import 'package:pesticides/Core/utils/SharedPrefsLocal.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/register/data/models/user_model_dto.dart';

import 'data/register_data_source.dart';

@Injectable(as: RegisterDataSource)
class RegisterDataSourceImpl implements RegisterDataSource {
  Future<Either<Failure, void>> addUserFireStore(UserAndAdminModelDto user) async {
    try {
      var userCollection = FirebaseUtils.getUserCollection(user.type ?? "");
      DocumentReference<UserAndAdminModelDto> userDoc = userCollection.doc();
      user.id = userDoc.id;
      await userDoc.set(user);
      return Right(null);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }


  Future<Either<Failure, String>> addImageToFirebaseStorage(File imgPath) async {
    try {
      final compressedImage = await FlutterImageCompress.compressWithFile(
        imgPath.path,
        minWidth: 800,
        minHeight: 600,
        quality: 80,
      );

      if (compressedImage == null) {
        throw Exception("Compression failed");
      }

      String imgName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref('uploads/$imgName');
      await storageRef.putData(compressedImage);
      String imgUrl = await storageRef.getDownloadURL();
      return Right(imgUrl);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  Future<Either<Failure, void>> registerFirebaseFireStore(String image, String type, String userName, String phone, String email) async {
    UserAndAdminModelDto user = UserAndAdminModelDto(
      image: image,
      type: type,
      userName: userName,
      phone: phone,
      email: email,
    );
    return await addUserFireStore(user);
  }

  @override
  Future<Either<Failure, void>> registerAuth(
      String? imagePath, // Make imagePath nullable to check if it's provided
      String type,
      String userName,
      String phone,
      String email,
      String password,
      ) async {
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String imageUrl = "";

      if (imagePath != null && imagePath.isNotEmpty) {
        final result = await addImageToFirebaseStorage(File(imagePath));
        result.fold(
              (_) {}, // Ignore failure
              (url) => imageUrl = url, // Use the URL if upload is successful
        );
      }

      UserAndAdminModelDto userAndAdminModelDto = UserAndAdminModelDto(
          image: imagePath, type: type, userName: userName, phone: phone, email: email);
      SharedPrefsLocal.saveData(key: StringManager.keyUserAdmin, model: userAndAdminModelDto);

      return await registerFirebaseFireStore(imageUrl, type, userName, phone, email);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return Left(Failure(errorMessage: 'Invalid credentials.'));
      } else if (e.code == 'email-already-in-use') {
        return Left(Failure(errorMessage: 'Email is already in use.'));
      } else if (e.code == 'network-request-failed') {
        return Left(Failure(errorMessage: 'Network request failed.'));
      } else {
        return Left(Failure(errorMessage: 'Authentication error.'));
      }
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }


}

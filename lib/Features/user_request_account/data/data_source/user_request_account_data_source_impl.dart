import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Core/utils/firebase_utils.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/user_request_account/data/data_source/data/user_request_account_data_source.dart';
import 'package:pesticides/Features/user_request_account/data/models/user_request_account_model_dto.dart';

@Injectable(as: UserRequestAccountDataSource)
class UserRequestAccountDataSourceImpl implements UserRequestAccountDataSource {
  static Future<void> addUserRequestAccountToFireStore(UserRequestAccountDto user) async {
    var collection = FirebaseUtils.getUserRequestAccountCollection(UserRequestAccountDto.requests);
    var docs = collection.doc();
    user.id = docs.id;
    return docs.set(user);
  }

  @override
  Future<Either<Failure, void>> userRequestAccountAuth(
    String? imagePath,
    String type,
    String userName,
    String phone,
    String email,
    String password,
  ) async {
    try {
      String imageUrl = "";

      if (imagePath != null && imagePath.isNotEmpty) {
        final result =
            await FirebaseUtils.addImageToFirebaseStorage(File(imagePath));
        result.fold(
          (_) {},
          (url) => imageUrl = url,
        );
      }
      UserRequestAccountDto userRequestAccountDto = UserRequestAccountDto(
          image: imageUrl,
          type: type,
          userName: userName,
          phone: phone,
          email: email,
          password: password
          );

      var userRequestAccounFireStore = await addUserRequestAccountToFireStore(userRequestAccountDto);

   

      return Right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        return Left(Failure(errorMessage: StringManager.badFormat));
      } else if (e.code == 'email-already-in-use') {
        return Left(Failure(errorMessage: StringManager.emailAlreadyInUse));
      } else if (e.code == 'network-request-failed') {
        return Left(Failure(errorMessage: StringManager.networkError));
      } else {
        return Left(Failure(errorMessage: StringManager.someThingWentWrong));
      }
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}

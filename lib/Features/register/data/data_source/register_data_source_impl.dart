import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Core/utils/firebase_utils.dart';
import 'package:pesticides/Core/utils/SharedPrefsLocal.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/register/data/models/user_model_dto.dart';
import 'data/register_data_source.dart';

@Injectable(as: RegisterDataSource)
class RegisterDataSourceImpl implements RegisterDataSource {
  static Future<void> addUserFireStore(UserAndAdminModelDto user) {
    return FirebaseUtils.getUserCollection(user.type ?? "")
        .doc(user.id)
        .set(user);
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
      var userFireStore = await addUserFireStore(userAndAdminModelDto);

      SharedPrefsLocal.saveData(
          key: StringManager.keyUserAdmin, model: userAndAdminModelDto);

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

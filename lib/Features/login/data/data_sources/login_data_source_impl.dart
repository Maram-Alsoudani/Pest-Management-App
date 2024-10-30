import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/login/data/data_sources/login_data_source.dart';
import 'package:pesticides/Features/register/data/models/user_model_dto.dart';

import '../../../../Core/utils/SharedPrefsLocal.dart';

@Injectable(as: LoginDataSource)
class LoginDataSourceImpl implements LoginDataSource {
  @override
  Future<Either<Failure, UserAndAdminModelDto?>> getUserFromFireStore(
      String type, String email) async {
    try {
      var collection = FirebaseFirestore.instance.collection(type);
      var querySnapshot =
          await collection.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data();

        var user = UserAndAdminModelDto.fromFireStore(userData);
        UserAndAdminModelDto userAndAdminModelDto = UserAndAdminModelDto(
            image: user.image,
            type: user.type,
            userName: user.userName,
            phone: user.phone,
            email: user.email);
        SharedPrefsLocal.saveData(
            key: StringManager.keyUserAdmin, model: userAndAdminModelDto);
        return Right(user);
      } else {
        return Left(Failure(errorMessage: "User not found"));
      }
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}

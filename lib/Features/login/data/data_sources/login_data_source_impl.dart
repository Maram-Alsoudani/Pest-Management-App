import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Core/utils/firebase_utils.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/login/data/data_sources/login_data_source.dart';
import 'package:pesticides/Features/register/data/models/user_model_dto.dart';

import '../../../../Core/utils/SharedPrefsLocal.dart';

@Injectable(as: LoginDataSource)
class LoginDataSourceImpl implements LoginDataSource {
  @override
  Future<Either<Failure, UserAndAdminModelDto?>> getUserFromFireStore(
      String type, String id) async {
    try {
      var querySnapshot = await FirebaseUtils.getUserCollection(type)
          .doc('FIl9ELiFhtCLAxnOe11s')
          .get();
      var data = querySnapshot.data();
      if (querySnapshot.exists && data != null) {
        return Right(data);
      } else {
        return Left(Failure(errorMessage: "User not found"));
      }
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }
}

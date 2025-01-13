import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'forget_password_data_source.dart';

@Injectable(as: ForgetPasswordDataSource)
class ForgetPasswordDataSourceImpl implements ForgetPasswordDataSource {
  @override
  Future<Either<Failure, void>> forgetPassword(String email) async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      try {
        var response = await FirebaseAuth.instance
            .sendPasswordResetEmail(email: email.trim());
        return Right(response);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'channel-error') {
          return Left(Failure(errorMessage: StringManager.errorOccurred));
        }
        if (e.code == 'invalid-email') {
          return Left(Failure(errorMessage: StringManager.badFormat));
        }
        return Left(Failure(errorMessage: StringManager.somethingWentWrong));
      }
    } else {
      return Left(NetworkFailure(errorMessage: StringManager.networkError));
    }
  }
}

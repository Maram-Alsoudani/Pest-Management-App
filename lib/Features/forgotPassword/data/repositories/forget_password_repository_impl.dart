import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/forgotPassword/data/data_sources/forget_password_data_source.dart';
import 'package:bug_away/Features/forgotPassword/domain/repositories/forget_password_repository.dart';

@Injectable(as: ForgetPasswordRepository)
class ForgetPasswordRepositoryImpl implements ForgetPasswordRepository {
  ForgetPasswordDataSource forgetPasswordDataSource;
  ForgetPasswordRepositoryImpl({required this.forgetPasswordDataSource});
  @override
  Future<Either<Failure, void>> forgetPassword(String email) async {
    var either = await forgetPasswordDataSource.forgetPassword(email);

    return either.fold((error) => Left(error), (response) => Right(response));
  }
}

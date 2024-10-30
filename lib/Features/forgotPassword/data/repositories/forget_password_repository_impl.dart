import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/forgotPassword/data/data_sources/forget_password_data_source.dart';
import 'package:pesticides/Features/forgotPassword/domain/repositories/forget_password_repository.dart';

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

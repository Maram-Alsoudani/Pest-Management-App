import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Features/user_request_account/domain/repositories/user_request_account_repo.dart';

import '../../../../Core/errors/failures.dart';
@injectable
class UserRequestAccountUseCase{
  UserRequestAccountRepo userRequestAccountRepo;
  UserRequestAccountUseCase({required this.userRequestAccountRepo});

  Future<Either<Failure, void>> userRequestAccountFireStore(String image,String type,String userName,String phone,  String email,  String password ) async {
    return userRequestAccountRepo.userRequestAccountFireStore(image, type, userName, phone, email, password);
  }
}
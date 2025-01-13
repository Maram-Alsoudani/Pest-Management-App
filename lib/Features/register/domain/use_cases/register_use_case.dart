import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Features/register/domain/repositories/register_repo.dart';

import '../../../../Core/errors/failures.dart';

@injectable
class RegisterUseCase {
  RegisterRepo registerRepo;
  RegisterUseCase({required this.registerRepo});

  Future<Either<Failure, void>> registerFireStore(String image, String type,
      String userName, String phone, String email, String password) async {
    return registerRepo.registerFireStore(
        image, type, userName, phone, email, password);
  }
}

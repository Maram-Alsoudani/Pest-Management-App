import 'package:dartz/dartz.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/register/domain/entities/user_model_entity.dart';

abstract class CategoryRepo {
  Future<Either<Failure, UserAndAdminModelEntity>>
      readUserOrAdminFromFireStore();
  Future<Either<Failure, void>> editUserData(UserAndAdminModelEntity user);
  Future<Either<Failure, void>> editImage(String? image);
  Future<Either<Failure, void>> removeFcm();
}

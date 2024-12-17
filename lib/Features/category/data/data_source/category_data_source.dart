import 'package:dartz/dartz.dart';

import '../../../../Core/errors/failures.dart';
import '../../../register/domain/entities/user_model_entity.dart';

abstract class CategoryDataSource {
  Future<Either<Failure, UserAndAdminModelEntity>>
      readUserOrAdminFromFireStore();
  Future<Either<Failure, void>> editUserData(UserAndAdminModelEntity user);
  Future<Either<Failure, void>> editImage(String? image);
  Future<Either<Failure, void>> removeFcm();
}

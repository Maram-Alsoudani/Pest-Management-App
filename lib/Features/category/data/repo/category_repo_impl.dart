import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/category/data/data_source/category_data_source.dart';

import 'package:bug_away/Features/register/domain/entities/user_model_entity.dart';

import '../../domin/repo/category_repo.dart';

@Injectable(as: CategoryRepo)
class CategoryRepoImpl implements CategoryRepo {
  CategoryDataSource categoryDataSource;
  CategoryRepoImpl({required this.categoryDataSource});
  @override
  Future<Either<Failure, UserAndAdminModelEntity>>
      readUserOrAdminFromFireStore() async {
    var either = await categoryDataSource.readUserOrAdminFromFireStore();

    return either.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, void>> editUserData(
      UserAndAdminModelEntity user) async {
    var either = await categoryDataSource.editUserData(user);

    return either.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, void>> editImage(String? image) async {
    var either = await categoryDataSource.editImage(image);

    return either.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, void>> removeFcm() async {
    var either = await categoryDataSource.removeFcm();

    return either.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}


import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/category/domin/repo/category_repo.dart';

import '../../../../Core/errors/failures.dart';
import '../../../register/domain/entities/user_model_entity.dart';
@injectable
class RemoveFcmFromFireStore{
  CategoryRepo categoryRepo;
  RemoveFcmFromFireStore({
    required this.categoryRepo});

  Future<Either<Failure, void>> invoke(){

    return categoryRepo.removeFcm();
  }
}
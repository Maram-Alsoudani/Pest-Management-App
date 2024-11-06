import 'package:dartz/dartz.dart';

import '../../../../../Core/errors/failures.dart';
import '../../../domain/entities/user_model_entity.dart';

abstract  class RegisterDataSource{
  Future<Either<Failure, void>> registerAuth(String image,String type,String userName,String phone,  String email,  String password) ;


}
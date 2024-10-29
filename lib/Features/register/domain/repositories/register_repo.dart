import 'package:dartz/dartz.dart';
import 'package:pesticides/Features/register/domain/entities/user_model_entity.dart';

import '../../../../Core/errors/failures.dart';

abstract class RegisterRepo{

  Future<Either<Failure, void>> registerFireStore(String image,String type,String userName,String phone,  String email,String password) ;


}
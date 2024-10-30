import 'package:dartz/dartz.dart';

import '../../../../../Core/errors/failures.dart';

abstract  class RegisterDataSource{
  Future<Either<Failure, void>> registerAuth(String image,String type,String userName,String phone,  String email,  String password) ;
}
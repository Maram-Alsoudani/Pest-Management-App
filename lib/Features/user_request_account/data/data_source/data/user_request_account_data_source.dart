import 'package:dartz/dartz.dart';

import '../../../../../Core/errors/failures.dart';

abstract  class UserRequestAccountDataSource{
  Future<Either<Failure, void>> userRequestAccountAuth(String image,String type,String userName,String phone,  String email,  String password) ;
}
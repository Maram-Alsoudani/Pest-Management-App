import 'package:dartz/dartz.dart';

import '../../../../Core/errors/failures.dart';

abstract class UserRequestAccountRepo{

  Future<Either<Failure, void>> userRequestAccountFireStore(String image,String type,String userName,String phone,  String email,String password) ;


}
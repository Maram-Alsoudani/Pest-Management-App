import 'package:bug_away/Features/forgotPassword/domain/entities/forget_password_entity.dart';

class ForgetPasswordDto extends ForgetPasswordEntity {
  ForgetPasswordDto({super.email});

  ForgetPasswordDto.fromFireStore(Map<String, dynamic> data)
      : this(email: data['email'] as String);
}

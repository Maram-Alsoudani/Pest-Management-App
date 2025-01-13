import 'package:bug_away/Features/user_request_account/domain/entities/user_request_account_model_entity.dart';

class UserRequestAccountDto extends UserRequestAccountEntity {
  static const String requests = "requests";

  UserRequestAccountDto({
    super.id,
    required super.image,
    required super.type,
    required super.userName,
    required super.phone,
    required super.email,
    required super.password,
    required super.dateTime,
    super.status,
  });

  UserRequestAccountDto.fromFireStore(Map<String, dynamic> data)
      : this(
          id: data["id"] as String,
          image: data["image"] as String,
          type: data["type"] as String,
          userName: data["userName"] as String,
          phone: data["phone"] as String,
          email: data["email"] as String,
          password: data["password"] as String,
          status: data["status"] as String?,
          dateTime: DateTime.fromMillisecondsSinceEpoch(data["dateTime"]),
        );

  Map<String, dynamic> toFireStore() {
    return {
      "id": id,
      "image": image,
      "type": type,
      "userName": userName,
      "phone": phone,
      "email": email,
      "password": password,
      "status": status,
      "dateTime": dateTime.millisecondsSinceEpoch,
    };
  }
}

import 'package:bug_away/Features/register/domain/entities/user_model_entity.dart';

class UserAndAdminModelDto extends UserAndAdminModelEntity {
  static const String user = "user";
  static const String admin = "admin";

  UserAndAdminModelDto({
    super.id,
    required super.image,
    required super.type,
    required super.userName,
    required super.phone,
    required super.email,
    super.fcmToken,
  });

  UserAndAdminModelDto.fromFireStore(Map<String, dynamic> data)
      : this(
          id: data["id"] as String,
          image: data["image"] as String,
          type: data["type"] as String,
          userName: data["userName"] as String,
          phone: data["phone"] as String,
          email: data["email"] as String,
          fcmToken: (data['fcmToken'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList(),
        );

  Map<String, dynamic> toFireStore() {
    return {
      "id": id,
      "image": image,
      "type": type,
      "userName": userName,
      "phone": phone,
      "email": email,
      "fcmToken": fcmToken,
    };
  }
}

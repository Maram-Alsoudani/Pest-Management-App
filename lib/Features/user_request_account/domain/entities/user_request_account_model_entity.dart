class UserRequestAccountEntity {

  String? id;
  String? image;
  String? type;
  String? userName;
  String? phone;
  String? email;
  String?password;

  UserRequestAccountEntity({
     this.id="",
    required this.image,
    required this.type,
    required this.userName,
    required this.phone,
    required this.email,
    required this.password,
  });


}

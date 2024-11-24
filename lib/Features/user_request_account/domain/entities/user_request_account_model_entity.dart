class UserRequestAccountEntity {

  String? id;
  String? image;
  String? type;
  String? userName;
  String? phone;
  String? email;
  String?password;
  String?status;
  DateTime dateTime;

  UserRequestAccountEntity({
     this.id="",
    required this.image,
    required this.type,
    required this.userName,
    required this.phone,
    required this.email,
    required this.password,
    required this.dateTime,
    this.status,
  });


}

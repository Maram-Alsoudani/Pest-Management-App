class UserAndAdminModelEntity {

  String? id;
  String? image;
  String? type;
  String? userName;
  String? phone;
  String? email;
  List<String>?fcmToken;


  UserAndAdminModelEntity({
     this.id="",
    required this.image,
    required this.type,
    required this.userName,
    required this.phone,
    required this.email,
     this.fcmToken,
  });


}

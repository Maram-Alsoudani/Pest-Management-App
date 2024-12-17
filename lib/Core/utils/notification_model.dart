class NotificationModel {
  static const String notification = "notification";
  String? id;
  String? title;
  String? body;
  String? route;
  DateTime? dateTime;
  String? to;

  NotificationModel({
    this.id = "",
    required this.title,
    required this.body,
    required this.route,
    required this.dateTime,
    required this.to,
  });

  NotificationModel.fromFireStore(Map<String, dynamic> data)
      : this(
          id: data["id"] as String,
          title: data["title"] as String,
          body: data["body"] as String,
          route: data["route"] as String,
          dateTime: DateTime.fromMillisecondsSinceEpoch(data["dateTime"]),
          to: data["to"] as String,
        );

  Map<String, dynamic> toFireStore() {
    return {
      "id": id,
      "title": title,
      "body": body,
      "route": route,
      "dateTime": dateTime?.millisecondsSinceEpoch,
      "to": to,
    };
  }
}

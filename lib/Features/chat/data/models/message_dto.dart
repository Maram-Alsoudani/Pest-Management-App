import 'package:bug_away/Features/chat/domain/entities/message_entity.dart';

class MessageDto extends MessageEntity {
  static const String messageCollection = "message";

  MessageDto({
    super.id = "",
    required super.content,
    required super.senderId,
    required super.senderName,
    required super.dateTime,
  });

  MessageDto.fromJson(Map<String, dynamic> json)
      : this(
          id: json["id"] as String,
          content: json["content"] as String,
          senderId: json["senderId"] as String,
          senderName: json["senderName"] as String,
          dateTime: DateTime.fromMillisecondsSinceEpoch(json["dateTime"]),
        );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "content": content,
      "senderId": senderId,
      "senderName": senderName,
      "dateTime": dateTime.millisecondsSinceEpoch,
    };
  }
}

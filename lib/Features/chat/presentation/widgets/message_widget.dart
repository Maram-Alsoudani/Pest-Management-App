import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Features/chat/domain/entities/message_entity.dart';
import 'package:bug_away/Features/chat/presentation/widgets/message_widget.dart';
import 'package:provider/provider.dart';

class MessageWidget extends StatelessWidget {
  MessageEntity message;
  String userId;
  final String dateTime;
  MessageWidget(
      {super.key,
      required this.message,
      required this.userId,
      required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return userId == message.senderId
        ? SentMessage(
            message: message,
            dateTime: dateTime,
          )
        : ReciveMessage(
            message: message,
            dateTime: dateTime,
          );
  }
}

class SentMessage extends StatelessWidget {
  MessageEntity message;
  final String dateTime;

  SentMessage({super.key, required this.message, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            message.senderName,
            style: const TextStyle(color: Colors.black),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            decoration: const BoxDecoration(
                color: ColorManager.blackColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                )),
            child: Text(message.content,
                style: const TextStyle(color: Colors.white)),
          ),
          Text(
            dateTime,
            style: const TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }
}

class ReciveMessage extends StatelessWidget {
  MessageEntity message;
  final String dateTime;

  ReciveMessage({super.key, required this.message, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.senderName,
            style: const TextStyle(color: Colors.black),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            decoration: BoxDecoration(
                color: Colors.blueGrey.shade700,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                )),
            child: Text(message.content,
                style: const TextStyle(color: Colors.white)),
          ),
          Text(
            dateTime,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

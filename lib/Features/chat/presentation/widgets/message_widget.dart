import 'package:flutter/material.dart';
import 'package:bug_away/Core/utils/colors.dart';
import 'package:bug_away/Features/chat/domain/entities/message_entity.dart';
import 'package:bug_away/Features/chat/presentation/manager/chat_view_model_cubit.dart';

class MessageWidget extends StatelessWidget {
  final MessageEntity message;
  final String userId;
  final String dateTime;
  final ChatViewModelCubit bloc;

  const MessageWidget({
    super.key,
    required this.message,
    required this.userId,
    required this.dateTime,
    required this.bloc,
  });

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
            userColor: bloc.getUserColor(message.senderId),
          );
  }
}

class SentMessage extends StatelessWidget {
  final MessageEntity message;
  final String dateTime;

  const SentMessage({super.key, required this.message, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: const BoxDecoration(
                color: ColorManager.primaryColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(22),
                  topLeft: Radius.circular(22),
                  bottomLeft: Radius.circular(22),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.content,
                  style: const TextStyle(color: ColorManager.whiteColor),
                ),
                const SizedBox(height: 5),
                Text(
                  dateTime,
                  style: const TextStyle(
                    color: ColorManager.subtitleGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReciveMessage extends StatelessWidget {
  final MessageEntity message;
  final String dateTime;
  final Color userColor;

  const ReciveMessage({
    super.key,
    required this.message,
    required this.dateTime,
    required this.userColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: const BoxDecoration(
                color: ColorManager.greyShade5,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(22),
                  topLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.senderName,
                  style: TextStyle(
                    color: userColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  message.content,
                  style: const TextStyle(color: ColorManager.whiteColor),
                ),
                const SizedBox(height: 5),
                Text(
                  dateTime,
                  style: const TextStyle(
                    color: ColorManager.subtitleGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

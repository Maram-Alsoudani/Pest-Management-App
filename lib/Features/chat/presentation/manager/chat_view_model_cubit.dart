import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Core/utils/SharedPrefsLocal.dart';
import 'package:bug_away/Core/utils/strings.dart';
import 'package:bug_away/Features/chat/data/models/message_dto.dart';
import 'package:bug_away/Features/chat/domain/entities/message_entity.dart';
import 'package:bug_away/Features/chat/domain/use_cases/get_message_use_case.dart';
import 'package:bug_away/Features/chat/domain/use_cases/send_message_use_case.dart';
import 'package:bug_away/Features/register/domain/entities/user_model_entity.dart';

part 'chat_view_model_state.dart';

@injectable
class ChatViewModelCubit extends Cubit<ChatViewModelState> {
  GetMessageUseCase getMessageUseCase;
  SendMessageUseCase sendMessageUseCase;

  ChatViewModelCubit({
    required this.getMessageUseCase,
    required this.sendMessageUseCase,
  }) : super(ChatViewModelInitial());
  String messageController = "";
  TextEditingController clearMessageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<MessageEntity> messages = [];
  void getMessage() async {
    var fold = await getMessageUseCase.invoke();
    fold.fold((l) {
      emit(ChatViewModelFailGetMessage(error: l));
    }, (stream) {
      stream.listen((message) {
        scrollToBottom();
        messages = message.docs.map((e) {
          dateTime = formatDateTime(e.data().dateTime);
          return e.data();
        }).toList();

        emit(ChatViewModelGetMessage());
      });
    });
  }

  void funcButton(String text) {
    messageController = text;
    emit(ChatViewModelButtonState());
  }

  void sendMessage() async {
    MessageDto message = MessageDto(
        content: messageController,
        senderId: user.id ?? "",
        senderName: user.userName ?? "",
        dateTime: DateTime.now());
    messageController = "";
    clearMessageController.clear();
    var fold = await sendMessageUseCase.invoke(message);
    fold.fold((l) {
      emit(ChatViewModelFailAddMessage(error: l));
    }, (r) {
      emit(ChatViewModelAddMessage());
    });
  }

  late UserAndAdminModelEntity user;
  UserAndAdminModelEntity? getUser() {
    var user = SharedPrefsLocal.getData(key: StringManager.keyUserAdmin);
    return user;
  }

  String dateTime = "";
  String formatDateTime(DateTime date) {
    DateTime datetime = DateTime.parse(date.toString());
    DateFormat formatter = DateFormat("yyyy-MM-dd HH:mm");
    String formatted = formatter.format(datetime);

    return formatted;
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Core/utils/SharedPrefsLocal.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/chat/data/models/message_dto.dart';
import 'package:pesticides/Features/chat/domain/entities/message_entity.dart';
import 'package:pesticides/Features/chat/domain/use_cases/get_message_use_case.dart';
import 'package:pesticides/Features/chat/domain/use_cases/send_message_use_case.dart';
import 'package:pesticides/Features/chat/presentation/widgets/message_widget.dart';
import 'package:pesticides/Features/register/domain/entities/user_model_entity.dart';

part 'chat_view_model_state.dart';

@injectable
class ChatViewModelCubit extends Cubit<ChatViewModelState> {
  GetMessageUseCase getMessageUseCase;
  SendMessageUseCase sendMessageUseCase;

  ChatViewModelCubit({
    required this.getMessageUseCase,
    required this.sendMessageUseCase,
  }) : super(ChatViewModelInitial());
  String messageController="";
  final ScrollController scrollController = ScrollController();
  Stream<QuerySnapshot<MessageEntity>>? streamMessage;
  void getMessage() async {
    var fold = await getMessageUseCase.invoke();
    fold.fold((l) {
      emit(ChatViewModelFailGetMessage(error: l));
    }, (r) {
      streamMessage = r;
      emit(ChatViewModelGetMessage());
    });
  }

 void funcButton(String text){
    messageController=text;
    emit(ChatViewModelButtonState());
  }


  void sendMessage() async {
    MessageDto message=MessageDto(
        content: messageController,
        senderId: user.id??"",
        senderName: user.userName??"",
        dateTime: DateTime.now());
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

  String dateTime="";
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
          duration:const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}



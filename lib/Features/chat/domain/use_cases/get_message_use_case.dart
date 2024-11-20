import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/chat/domain/entities/message_entity.dart';
import 'package:pesticides/Features/chat/domain/repositories/chat_repo.dart';
@injectable
class GetMessageUseCase{
  ChatRepo chatRepo;
  GetMessageUseCase({required this.chatRepo});


  Future<Either<Failure,Stream<QuerySnapshot<MessageEntity>>>> invoke()async{
    return chatRepo.getMessage();
  }
}
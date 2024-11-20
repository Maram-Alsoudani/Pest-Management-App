import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/chat/data/models/message_dto.dart';
import 'package:pesticides/Features/chat/domain/entities/message_entity.dart';

abstract class ChatRepo{
  Future<Either<Failure,Stream<QuerySnapshot<MessageEntity>>>>getMessage();
  Future<Either<Failure,void>> sendMessage(MessageDto message);
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/chat/data/models/message_dto.dart';
import 'package:bug_away/Features/chat/domain/entities/message_entity.dart';

abstract class ChatDataSource {
  Future<Either<Failure, Stream<QuerySnapshot<MessageEntity>>>> getMessage();
  Future<Either<Failure, void>> sendMessage(MessageDto message);
}

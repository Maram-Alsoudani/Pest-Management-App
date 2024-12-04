import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/chat/data/data_sources/chat_data_source.dart';
import 'package:bug_away/Features/chat/data/models/message_dto.dart';
import 'package:bug_away/Features/chat/domain/entities/message_entity.dart';
import 'package:bug_away/Features/chat/domain/repositories/chat_repo.dart';

@Injectable(as: ChatRepo)
class ChatRepoImpl implements ChatRepo {
  ChatDataSource chatDataSource;
  ChatRepoImpl({required this.chatDataSource});
  @override
  Future<Either<Failure, Stream<QuerySnapshot<MessageEntity>>>>
      getMessage() async {
    var either = await chatDataSource.getMessage();
    return either.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, void>> sendMessage(MessageDto message) async {
    var either = await chatDataSource.sendMessage(message);
    return either.fold((l) => Left(l), (r) => Right(r));
  }
}

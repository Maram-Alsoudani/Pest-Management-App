import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/chat/data/models/message_dto.dart';
import 'package:bug_away/Features/chat/domain/repositories/chat_repo.dart';

@injectable
class SendMessageUseCase {
  ChatRepo chatRepo;
  SendMessageUseCase({required this.chatRepo});

  Future<Either<Failure, void>> invoke(MessageDto message) async {
    return chatRepo.sendMessage(message);
  }
}

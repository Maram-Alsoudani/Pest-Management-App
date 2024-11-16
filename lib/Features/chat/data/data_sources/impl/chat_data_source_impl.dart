import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Core/utils/firebase_utils.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/chat/data/data_sources/chat_data_source.dart';
import 'package:pesticides/Features/chat/data/models/message_dto.dart';
import 'package:pesticides/Features/chat/domain/entities/message_entity.dart';
@Injectable(as: ChatDataSource)
class ChatDataSourceImpl implements ChatDataSource{
  @override
  Future<Either<Failure, Stream<QuerySnapshot<MessageDto>>>> getMessage()async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {

         Stream<QuerySnapshot<MessageDto>> streamMessage= FirebaseUtils.getMessageFromFireStore();

         return Right(streamMessage);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      return Left(Failure(errorMessage: StringManager.someThingWentWrong));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(MessageDto message) async{
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {


    var result = await FirebaseUtils.insertMessage(message);

      return Right(null);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      return Left(Failure(errorMessage: StringManager.someThingWentWrong));
    }
  }
}
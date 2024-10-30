import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Features/register/data/models/user_model_dto.dart';

class FirebaseUtils {
  static CollectionReference<UserAndAdminModelDto> getUserCollection(
      String type) {
    return FirebaseFirestore.instance
        .collection(type)
        .withConverter<UserAndAdminModelDto>(
          fromFirestore: (snapshot, options) =>
              UserAndAdminModelDto.fromFireStore(snapshot.data()!),
          toFirestore: (user, options) => user.toFireStore(),
        );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../Features/inventory/data/models/materail_model_dto.dart';
import '../../Features/register/data/models/user_model_dto.dart';
import '../errors/failures.dart';

class FirebaseUtils {
  static CollectionReference<UserAndAdminModelDto> getUserCollection(
      String type) {
    return FirebaseFirestore.instance
        .collection(type)
        .withConverter<UserAndAdminModelDto>(
          fromFirestore: (snapshot, options){

            return UserAndAdminModelDto.fromFireStore(snapshot.data()!);
          }
              ,
          toFirestore: (user, options) => user.toFireStore(),
        );
  }
  static CollectionReference<MaterialDto> getMaterailCollection(
      ) {
    return FirebaseFirestore.instance
        .collection(MaterialDto.collectionName)
        .withConverter<MaterialDto>(
      fromFirestore: (snapshot, options) {

       return MaterialDto.fromMap(snapshot.data()!);
      }
          ,
      toFirestore: (user, options) => user.toMap(),
    );
  }

  static Future<Either<Failure, String>> addImageToFirebaseStorage(File imgPath) async {
    try {
      final compressedImage = await FlutterImageCompress.compressWithFile(
        imgPath.path,
        minWidth: 800,
        minHeight: 600,
        quality: 80,
      );

      if (compressedImage == null) {
        throw Exception("Compression failed");
      }

      String imgName = DateTime.now().millisecondsSinceEpoch.toString();
      final storageRef = FirebaseStorage.instance.ref('uploads/$imgName');
      await storageRef.putData(compressedImage);
      String imgUrl = await storageRef.getDownloadURL();
      print(imgUrl);
      return Right(imgUrl);
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

}

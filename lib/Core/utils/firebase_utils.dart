import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:pesticides/Features/reports/domain/entities/site_entity.dart';
import '../../Features/inventory/data/models/materail_model_dto.dart';
import '../../Features/register/data/models/user_model_dto.dart';
import '../../Features/reports/data/models/site_dto.dart';
import '../errors/failures.dart';

class FirebaseUtils {
  static CollectionReference<UserAndAdminModelDto> getUserCollection(
      String type) {
    return FirebaseFirestore.instance
        .collection(type)
        .withConverter<UserAndAdminModelDto>(
          fromFirestore: (snapshot, options) {
            return UserAndAdminModelDto.fromFireStore(snapshot.data()!);
          },
          toFirestore: (user, options) => user.toFireStore(),
        );
  }

  static CollectionReference<MaterailModelDto> getMaterailCollection() {
    return FirebaseFirestore.instance
        .collection(MaterailModelDto.collectionName)
        .withConverter<MaterailModelDto>(
          fromFirestore: (snapshot, options) {
            return MaterailModelDto.fromFireStore(snapshot.data()!);
          },
          toFirestore: (user, options) => user.toFirestore(),
        );
  }

  static Future<Either<Failure, String>> addImageToFirebaseStorage(
      File imgPath) async {
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

  //todo============*( SITES FIREBASE )*=================

  static Future<List<UserAndAdminModelDto>> readUserFromFireStore() async {
    final users = await FirebaseFirestore.instance.collection('user').get();
    return users.docs
        .map((doc) => UserAndAdminModelDto.fromFireStore(doc.data()))
        .toList();
//todo ================= Another Way to do it ===============
    /*  var users = await getUserCollection('user')
        .where('id')
        .withConverter<UserAndAdminModelDto>(
            fromFirestore: (snapshot, _) =>
                UserAndAdminModelDto.fromFireStore(snapshot.data()!),
            toFirestore: (users, _) => users.toFireStore())
        .get();

    for (var doc in users.docs) {
      list.add(doc.data());
    }*/
  }

  static CollectionReference<SiteDto> getSiteCollection({required String uId}) {
    return getUserCollection('user')
        .doc(uId)
        .collection(SiteEntity.collectionName)
        .withConverter<SiteDto>(
            fromFirestore: (snapshot, _) =>
                SiteDto.fromFireStore(snapshot.data()!),
            toFirestore: (site, _) => site.toFireStore());
  }

  static Future<void> addSiteToUsersFireStore(
      {required SiteDto site, required String uId}) {
    var siteCollection = getSiteCollection(uId: uId);
    var siteDocRef = siteCollection.doc();
    site.siteId = siteDocRef.id; // this make an auto Id;
    return siteDocRef.set(site);
  }

  static Future<List<SiteDto>> fetchAllSitesAcrossAllUsers() async {
    List<SiteDto> allSites = [];
    var userCollection = FirebaseUtils.getUserCollection('user');

    // Step 1: Get all user documents
    var usersSnapshot = await userCollection.get();

    // Step 2: For each user, get sites from their subcollection
    for (var userDoc in usersSnapshot.docs) {
      var userId = userDoc.id;
      var siteCollection = userDoc.reference
          .collection(SiteEntity.collectionName)
          .withConverter<SiteDto>(
            fromFirestore: (snapshot, _) =>
                SiteDto.fromFireStore(snapshot.data()!),
            toFirestore: (site, _) => site.toFireStore(),
          );

      // Step 3: Retrieve all sites in this user's subcollection
      var sitesSnapshot = await siteCollection.get();
      var userSites = sitesSnapshot.docs.map((doc) => doc.data()).toList();

      // Step 4: Add these sites to the allSites list
      allSites.addAll(userSites);
    }

    return allSites;
  }
}

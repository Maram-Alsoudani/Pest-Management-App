import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../Features/chat/data/models/message_dto.dart';
import '../../Features/inventory/data/models/materail_model_dto.dart';
import '../../Features/register/data/models/user_model_dto.dart';
import '../../Features/reports/data/models/site_dto.dart';
import '../../Features/reports/domain/entities/site_entity.dart';
import '../../Features/site_report/data/models/report_dto.dart';
import '../../Features/user_request_account/data/models/user_request_account_model_dto.dart';
import '../errors/failures.dart';
import 'notification_model.dart';

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

  static CollectionReference<UserRequestAccountDto>
      getUserRequestAccountCollection(String name) {
    return FirebaseFirestore.instance
        .collection(name)
        .withConverter<UserRequestAccountDto>(
          fromFirestore: (snapshot, options) {
            return UserRequestAccountDto.fromFireStore(snapshot.data()!);
          },
          toFirestore: (user, options) => user.toFireStore(),
        );
  }

  static Stream<QuerySnapshot<UserRequestAccountDto>>
      getRequestFromFireStore() {
    return getUserRequestAccountCollection(UserRequestAccountDto.requests)
        .orderBy("dateTime", descending: true)
        .snapshots();
  }

  static CollectionReference<MaterailModelDto> getMaterailCollection() {
    return FirebaseFirestore.instance
        .collection(MaterailModelDto.collectionName)
        .withConverter<MaterailModelDto>(
          fromFirestore: (snapshot, options) {
            return MaterailModelDto.fromFireStore(snapshot.data()!);
          },
          toFirestore: (material, options) => material.toFirestore(),
        );
  }

  static Future<List<MaterailModelDto>> fetchAllMaterials() async {
    var materialCollection = getMaterailCollection();
    var materialsSnapshot = await materialCollection.get();
    return materialsSnapshot.docs.map((doc) => doc.data()).toList();
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
    site.siteId = siteDocRef.id;
    return siteDocRef.set(site);
  }

  static Future<List<SiteDto>> fetchAllSitesAcrossAllUsers() async {
    List<SiteDto> allSites = [];
    var userCollection = FirebaseUtils.getUserCollection('user');

    // Step 1: Get all user documents
    var usersSnapshot = await userCollection.get();

    // Step 2: For each user, get sites from their subcollection
    for (var userDoc in usersSnapshot.docs) {
      var siteCollection = userDoc.reference
          .collection(SiteEntity.collectionName)
          .withConverter<SiteDto>(
            fromFirestore: (snapshot, _) => SiteDto.fromFireStore(
              snapshot.data()!,
            ), // Pass userId here
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

  static Future<List<SiteDto>> getUserSite(String uId) async {
    var sites = FirebaseUtils.getSiteCollection(uId: uId);
    var siteDoc = await sites.get();
    return siteDoc.docs.map((doc) => doc.data()).toList();
  }

  //todo============*( REPORTS FIREBASE )*=================

  static CollectionReference<Map<String, dynamic>> getReportCollection() {
    return FirebaseFirestore.instance.collection('reports');
  }

  static Future<void> addReportToUsersFireStore({required ReportModel report}) {
    var reportCollection = getReportCollection();
    var reportDocRef = reportCollection.doc();
    report.id = reportDocRef.id;
    return reportDocRef.set(report.toJson());
  }

  static Future<List<ReportModel>> fetchAllReportsAcrossAllUsers() async {
    List<ReportModel> allReports = [];
    var reportCollection = getReportCollection();
    var reportsSnapshot = await reportCollection.get();
    for (var reportDoc in reportsSnapshot.docs) {
      allReports.add(ReportModel.fromJson(reportDoc.data()));
    }
    return allReports;
  }

  //todo============*( MATERIALS FIREBASE )*=================

  static Future<void> updateMaterialQuantityByName(
      String materialName, int change) async {
    var materialCollection = getMaterailCollection();
    var querySnapshot =
        await materialCollection.where('name', isEqualTo: materialName).get();
    if (querySnapshot.docs.isEmpty) {
      throw Exception("Material with name $materialName does not exist!");
    }
    var materialDoc = querySnapshot.docs.first.reference;
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      var snapshot = await transaction.get(materialDoc);
      var newQuantity = (snapshot.data()!.quantity ?? 0) + change;
      if (newQuantity < 0) {
        throw Exception(
            "Insufficient quantity for material with name $materialName!");
      }
      transaction.update(materialDoc, {'quantity': newQuantity});
    });
  }

  //todo============*( delete Feature )*=================

  static Future<void> deleteSites(SiteDto site) async {
    return FirebaseUtils.getUserCollection('user')
        .doc(site.userId)
        .collection('site')
        .doc(site.siteId)
        .delete();
  }

  //todo============*( Chat Feature )*=================
  static CollectionReference<MessageDto> getMessageCollection() {
    return FirebaseFirestore.instance
        .collection(MessageDto.messageCollection)
        .withConverter<MessageDto>(
          fromFirestore: (snapshot, options) =>
              MessageDto.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  static Stream<QuerySnapshot<MessageDto>> getMessageFromFireStore() {
    return getMessageCollection().orderBy("dateTime").snapshots();
  }

  static Future<void> insertMessage(MessageDto message) async {
    var messageCollection = getMessageCollection();
    var docRef = messageCollection.doc();
    message.id = docRef.id;
    return await docRef.set(message);
  }

  static CollectionReference<NotificationModel> getNotificationCollection(
      String type, String uid) {
    return getUserCollection(type)
        .doc(uid)
        .collection(NotificationModel.notification)
        .withConverter<NotificationModel>(
          fromFirestore: (snapshot, options) {
            return NotificationModel.fromFireStore(snapshot.data()!);
          },
          toFirestore: (user, options) => user.toFireStore(),
        );
  }

  static Future<void> saveNotification(
      NotificationModel notification, String type, String uid) async {
    var notificationCollection = getNotificationCollection(type, uid);
    var docRef = notificationCollection.doc();
    notification.id = docRef.id;
    return await docRef.set(notification);
  }

  static Future<List<UserAndAdminModelDto>> getAdminOrUserTokenFromFireStore(
      String type) async {
    var docSnapshot = await FirebaseUtils.getUserCollection(type).get();
    var data = docSnapshot.docs;

    List<UserAndAdminModelDto> list = data.map((e) {
      return e.data();
    }).toList();
    return list;
  }
}

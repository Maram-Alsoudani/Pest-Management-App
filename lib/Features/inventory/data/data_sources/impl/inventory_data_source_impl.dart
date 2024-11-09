import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Core/utils/firebase_utils.dart';
import 'package:pesticides/Core/utils/strings.dart';
import 'package:pesticides/Features/inventory/data/data_sources/impl/inventory_data_source_impl.dart';
import 'package:pesticides/Features/inventory/data/data_sources/inventory_data_source.dart';
import 'package:pesticides/Features/inventory/data/models/materail_model_dto.dart';

import '../../../domain/entities/materail_enitiy.dart';

@Injectable(as: InventoryDataSource)
class InventoryDataSourceImpl implements InventoryDataSource {
  Future<void> addMaterailsFireStore(MaterailModelDto materails) {
    var taskCollection = FirebaseUtils.getMaterailCollection();
    DocumentReference<MaterailModelDto> taskDoc = taskCollection.doc();
    materails.id = taskDoc.id;
    return  taskDoc.set(materails);
  }
   Future<void> editMaterail(
      MaterailModelDto materails
      ) async {
    var taskCollection = FirebaseUtils.getMaterailCollection();
    return  taskCollection.doc(materails.id).update({
      'name': materails.name,
      'quantity': materails.quantity,
    });}

  Future<void> deleteMaterailsFireStore(String id) {
    return FirebaseUtils.getMaterailCollection()
        .doc(id)
        .delete();
  }

  @override
  Future<Either<Failure, void>> addedMaterail(MaterailEntity materail) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        MaterailModelDto materails =
            MaterailModelDto(name: materail.name, quantity: materail.quantity);
        await addMaterailsFireStore(materails);
        return const Right(null);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      return Left(Failure(errorMessage: StringManager.someThingWentWrong));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMaterail(String id) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        await deleteMaterailsFireStore(id);
        return const Right(null);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      print(e);
      return Left(Failure(errorMessage: StringManager.someThingWentWrong));
    }
  }

  @override
  Future<Either<Failure, List<MaterailModelDto>>>
      fetchMaterialsList() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        var docSnapshot =
            await FirebaseUtils.getMaterailCollection().get();
        var data=docSnapshot.docs;

        List<MaterailModelDto> list=data.map((e) =>e.data()).toList();
        return  Right(list);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      return Left(Failure(errorMessage: StringManager.someThingWentWrong));
    }
  }

  @override
  Future<Either<Failure, void>> updateMaterail(String id,String name, int quantity)async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        print("osman=====================================$id");
        MaterailModelDto materails=MaterailModelDto(id:id,name: name, quantity: quantity);
        var editFunc=await editMaterail(materails);

        return  Right(null);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      return Left(Failure(errorMessage: StringManager.someThingWentWrong));
    }
  }
}

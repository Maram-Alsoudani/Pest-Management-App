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

@Injectable(as: InventoryDataSource)
class InventoryDataSourceImpl implements InventoryDataSource {
  Future<void> addMaterailsFireStore(MaterialDto materails) {
    return FirebaseUtils.getMaterailCollection()
        .doc("UtPHeI3lz08jLLCU9MMO")
        .update(materails.toMap());
  }

  Future<void> deleteMaterailsFireStore(String key) {

    return FirebaseUtils.getMaterailCollection()
        .doc("UtPHeI3lz08jLLCU9MMO")
        .update({
      key:FieldValue.delete()
    });
  }

  @override
  Future<Either<Failure, void>> addedMaterail(
      Map<String, dynamic> materail) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        MaterialDto materialData = MaterialDto(
          materials: {
            materail["name"]: materail,
          },
        );

        await addMaterailsFireStore(materialData);
        return const Right(null);
      } else {
        return Left(Failure(errorMessage: "No internet connection"));
      }
    } catch (e) {
      return Left(Failure(errorMessage: "An error occurred: $e"));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
      fetchMaterialsList() async {
    try {
      // Check connectivity
      var connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        var docSnapshot = await FirebaseUtils.getMaterailCollection()
            .doc("UtPHeI3lz08jLLCU9MMO")
            .get();

        var data = docSnapshot.data()!.materials;
        List<Map<String, dynamic>> materialsList = [];
        data.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            materialsList.add(value);
          }
        });

        return Right(materialsList);
      } else {
        return Left(Failure(errorMessage: StringManager.networkError));
      }
    } catch (e) {
      return Left(Failure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMaterail(
      String key) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.wifi) ||
          connectivityResult.contains(ConnectivityResult.mobile)) {
        await deleteMaterailsFireStore(key);
        return const Right(null);
      } else {
        return Left(Failure(errorMessage: "No internet connection"));
      }
    } catch (e) {
      print(e);
      return Left(Failure(errorMessage: "An error occurred: $e"));
    }
  }
}

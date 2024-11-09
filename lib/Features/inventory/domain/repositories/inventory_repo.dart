import 'package:dartz/dartz.dart';
import 'package:pesticides/Core/errors/failures.dart';

abstract class InventoryRepo{
  Future<Either<Failure,void>> addedMaterail(Map<String,dynamic> materail);
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchMaterialsList();
  Future<Either<Failure, void>> deleteMaterail( String key);
}
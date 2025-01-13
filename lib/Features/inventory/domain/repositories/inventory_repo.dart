import 'package:dartz/dartz.dart';
import 'package:bug_away/Core/errors/failures.dart';

import '../entities/materail_enitiy.dart';

abstract class InventoryRepo {
  Future<Either<Failure, void>> addedMaterail(MaterailEntity materail);
  Future<Either<Failure, List<MaterailEntity>>> fetchMaterialsList();
  Future<Either<Failure, void>> deleteMaterail(String key);
  Future<Either<Failure, void>> updateMaterail(
      String id, String name, int quantity, String unit);
  Future<Either<Failure, void>> incrementQuantity(String id, int quantity);
  Future<Either<Failure, void>> decrementQuantity(String id, int quantity);
}

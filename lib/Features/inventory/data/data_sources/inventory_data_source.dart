import 'package:dartz/dartz.dart';
import 'package:bug_away/Core/errors/failures.dart';

import '../../domain/entities/materail_enitiy.dart';

abstract class InventoryDataSource {
  Future<Either<Failure, void>> addedMaterail(MaterailEntity materail);
  Future<Either<Failure, List<MaterailEntity>>> fetchMaterialsList();
  Future<Either<Failure, void>> deleteMaterail(String key);
  Future<Either<Failure, void>> updateMaterail(
      String id, String name, int quantity);
}

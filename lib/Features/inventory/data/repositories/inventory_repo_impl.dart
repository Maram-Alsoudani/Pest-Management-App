import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/inventory/data/data_sources/inventory_data_source.dart';
import 'package:bug_away/Features/inventory/domain/repositories/inventory_repo.dart';

import '../../domain/entities/materail_enitiy.dart';

@Injectable(as: InventoryRepo)
class InventoryRepoImpl implements InventoryRepo {
  InventoryDataSource inventoryDataSource;
  InventoryRepoImpl({required this.inventoryDataSource});
  @override
  Future<Either<Failure, void>> addedMaterail(MaterailEntity materail) async {
    var either = await inventoryDataSource.addedMaterail(materail);

    return either.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, List<MaterailEntity>>> fetchMaterialsList() async {
    var either = await inventoryDataSource.fetchMaterialsList();

    return either.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, void>> deleteMaterail(String key) async {
    var either = await inventoryDataSource.deleteMaterail(key);

    return either.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, void>> updateMaterail(
      String id, String name, int quantity, String unit) async {
    var either =
        await inventoryDataSource.updateMaterail(id, name, quantity, unit);

    return either.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, void>> incrementQuantity(
      String id, int quantity) async {
    var either = await inventoryDataSource.incrementQuantity(id, quantity);

    return either.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }

  @override
  Future<Either<Failure, void>> decrementQuantity(
      String id, int quantity) async {
    var either = await inventoryDataSource.decrementQuantity(id, quantity);

    return either.fold(
      (l) => Left(l),
      (r) => Right(r),
    );
  }
}

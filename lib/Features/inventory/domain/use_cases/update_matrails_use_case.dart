import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/inventory/domain/repositories/inventory_repo.dart';

@injectable
class UpdateMaterialUseCase {
  final InventoryRepo inventoryRepo;

  UpdateMaterialUseCase({required this.inventoryRepo});

  Future<Either<Failure, void>> invoke(
      String id, String name, int quantity, String unit) {
    return inventoryRepo.updateMaterail(id, name, quantity, unit);
  }
}

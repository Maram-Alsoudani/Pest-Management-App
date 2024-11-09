
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/inventory/domain/repositories/inventory_repo.dart';
@injectable
class UpdateMaterialUseCase {
  final InventoryRepo inventoryRepo;

  UpdateMaterialUseCase({required this.inventoryRepo});

  Future<Either<Failure, void>> invoke(String id,String name, int quantity) {
    return inventoryRepo.updateMaterail(id, name, quantity);
  }
}

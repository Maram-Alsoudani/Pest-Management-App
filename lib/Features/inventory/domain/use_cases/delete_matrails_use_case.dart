
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/inventory/domain/repositories/inventory_repo.dart';
@injectable
class DeleteMaterialUseCase {
  final InventoryRepo inventoryRepo;

  DeleteMaterialUseCase({required this.inventoryRepo});

  Future<Either<Failure, void>> invoke(String key) {
    return inventoryRepo.deleteMaterail( key);
  }
}

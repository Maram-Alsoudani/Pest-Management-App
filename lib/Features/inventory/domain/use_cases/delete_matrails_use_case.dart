import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/inventory/domain/repositories/inventory_repo.dart';

@injectable
class DeleteMaterialUseCase {
  final InventoryRepo inventoryRepo;

  DeleteMaterialUseCase({required this.inventoryRepo});

  Future<Either<Failure, void>> invoke(String key) {
    return inventoryRepo.deleteMaterail(key);
  }
}

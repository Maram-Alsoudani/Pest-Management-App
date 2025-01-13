import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Core/errors/failures.dart';
import 'package:bug_away/Features/inventory/domain/repositories/inventory_repo.dart';

import '../entities/materail_enitiy.dart';

@injectable
class GetMaterailUseCase {
  InventoryRepo inventoryRepo;
  GetMaterailUseCase({required this.inventoryRepo});

  Future<Either<Failure, List<MaterailEntity>>> fetchMaterialsList() {
    return inventoryRepo.fetchMaterialsList();
  }
}

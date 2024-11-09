
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/inventory/domain/repositories/inventory_repo.dart';

import '../entities/materail_enitiy.dart';
@injectable
class GetMaterailUseCase{
  InventoryRepo inventoryRepo;
  GetMaterailUseCase({required this.inventoryRepo});

  Future<Either<Failure, List<MaterailEntity>>> fetchMaterialsList() {
    return inventoryRepo.fetchMaterialsList();
  }
}
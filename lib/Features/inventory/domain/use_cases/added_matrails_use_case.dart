
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:pesticides/Core/errors/failures.dart';
import 'package:pesticides/Features/inventory/domain/repositories/inventory_repo.dart';
@injectable
class AddedMaterailUseCase{
  InventoryRepo inventoryRepo;
  AddedMaterailUseCase({required this.inventoryRepo});

  Future<Either<Failure,void>> invoke(Map<String,dynamic> materail){
    return inventoryRepo.addedMaterail(materail);
  }
}
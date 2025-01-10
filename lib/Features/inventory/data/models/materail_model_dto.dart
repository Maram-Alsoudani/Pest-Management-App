import '../../domain/entities/materail_enitiy.dart';

class MaterailModelDto extends MaterailEntity {
  static const String collectionName = "materail";

  MaterailModelDto({
    required super.name,
    required super.quantity,
    required super.unit,
    super.id = "",
  });

  MaterailModelDto.fromFireStore(Map<String, dynamic> data)
      : this(
          name: data["name"] as String,
          quantity: data["quantity"] as int,
          unit: data["unit"] as String,
          id: data["id"] as String,
        );

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "quantity": quantity,
      "unit": unit,
      "id": id,
    };
  }
}

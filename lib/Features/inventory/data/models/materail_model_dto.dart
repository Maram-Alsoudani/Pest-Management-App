
import 'package:pesticides/Features/inventory/domain/entities/materail_enitiy.dart';

class MaterialDto extends MaterailEntity{
  static const String collectionName = "materials";


  MaterialDto({required super.materials});

  Map<String, dynamic> toMap() {
    return materials;
  }

  factory MaterialDto.fromMap(Map<String, dynamic> map) {
    Map<String, Map<String, dynamic>> materials = {};

    map.forEach((key, value) {
      materials[key] = Map<String, dynamic>.from(value);
    });

    return MaterialDto(materials: materials);
  }
}






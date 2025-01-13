import 'package:bug_away/Core/utils/images.dart';

class CategoryModel {
  String image;

  String name;
  CategoryModel({required this.image, required this.name});

  static List<CategoryModel> images = [
    CategoryModel(image: ImageManager.location, name: "SITES"),
    CategoryModel(image: ImageManager.report, name: "REPORTS"),
    CategoryModel(image: ImageManager.monitor, name: "INVENTORY"),
  ];
}

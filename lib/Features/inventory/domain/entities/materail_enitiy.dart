class MaterailEntity {
  String id;
  String? name;
  int? quantity;
  String? unit;

  MaterailEntity({
    required this.name,
    required this.quantity,
    this.unit,
    this.id = "",
  });
}

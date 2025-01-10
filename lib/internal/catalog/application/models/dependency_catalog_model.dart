
import 'package:help_desk/internal/catalog/domain/entities/dependency.dart';

class CatalogModel extends Catalog {
  CatalogModel({
    super.value,
    super.label,
  });

  factory CatalogModel.fromJson(Map<String, dynamic> json) {
    return CatalogModel(
      value: json["value"],
      label: json["label"],
    );
  }

  factory CatalogModel.fromEntity(Catalog dependency) {
    return CatalogModel(
      value: dependency.value,
      label: dependency.label,
    );
  }
}


import 'package:help_desk/internal/users/catalog/domain/entities/dependency.dart';

class CatalogModel extends Catalog {
  CatalogModel({
    super.value,
    super.label,
    super.decentralized,
  });

  factory CatalogModel.fromJson(Map<String, dynamic> json) {
    return CatalogModel(
      value: json["value"],
      label: json["label"],
      decentralized: json["descentralizada"],
    );
  }

  factory CatalogModel.fromEntity(Catalog dependency) {
    return CatalogModel(
      value: dependency.value,
      label: dependency.label,
      decentralized: dependency.decentralized,
    );
  }
}

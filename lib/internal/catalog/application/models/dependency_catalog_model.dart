
import 'package:help_desk/internal/catalog/domain/entities/dependency.dart';

class DependencyCatalogModel extends DependencyCatalog {
  DependencyCatalogModel({
    super.value,
    super.label,
  });

  factory DependencyCatalogModel.fromJson(Map<String, dynamic> json) {
    return DependencyCatalogModel(
      value: json["value"],
      label: json["label"],
    );
  }

  factory DependencyCatalogModel.fromEntity(DependencyCatalog dependency) {
    return DependencyCatalogModel(
      value: dependency.value,
      label: dependency.label,
    );
  }
}

import 'package:help_desk/internal/catalog/domain/entities/dependency.dart';

abstract class DependencyCatalogRepository {
  Future<List<DependencyCatalog>> getDependencies();
}

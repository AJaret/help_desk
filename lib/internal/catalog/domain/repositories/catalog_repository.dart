import 'package:help_desk/internal/catalog/domain/entities/dependency.dart';

abstract class CatalogRepository {
  Future<List<Catalog>> getDependencies();
  Future<List<Catalog>> getPhysicalLocations();
}

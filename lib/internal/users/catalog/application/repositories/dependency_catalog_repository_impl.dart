
import 'package:help_desk/internal/users/catalog/application/datasources/catalog_api_datasource.dart';
import 'package:help_desk/internal/users/catalog/domain/entities/dependency.dart';
import 'package:help_desk/internal/users/catalog/domain/repositories/catalog_repository.dart';

class DependencyCatalogRepositoryImpl implements CatalogRepository {
  final CatalogApiDatasourceImp datasource;

  DependencyCatalogRepositoryImpl({required this.datasource});

  @override
  Future<List<Catalog>> getDependencies() async{
    try {
      return await datasource.getDependencies();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  
  @override
  Future<List<Catalog>> getPhysicalLocations() async{
    try {
      return await datasource.getPhysicalLocations();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

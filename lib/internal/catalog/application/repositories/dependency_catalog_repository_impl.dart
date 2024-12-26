
import 'package:help_desk/internal/catalog/application/datasources/dependency_catalog_api_datasource.dart';
import 'package:help_desk/internal/catalog/domain/entities/dependency.dart';
import 'package:help_desk/internal/catalog/domain/repositories/dependency_catalog_repository.dart';

class DependencyCatalogRepositoryImpl implements DependencyCatalogRepository {
  final DependencyCatalogApiDatasourceImp datasource;

  DependencyCatalogRepositoryImpl({required this.datasource});

  @override
  Future<List<DependencyCatalog>> getDependencies() async{
    try {
      return await datasource.getDependencies();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

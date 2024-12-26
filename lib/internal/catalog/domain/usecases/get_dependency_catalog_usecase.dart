import 'package:help_desk/internal/catalog/domain/entities/dependency.dart';
import 'package:help_desk/internal/catalog/domain/repositories/dependency_catalog_repository.dart';

class GetDependencyCatalogUseCase {
  final DependencyCatalogRepository dependencycatalogRepo;

  GetDependencyCatalogUseCase({required this.dependencycatalogRepo});

  Future<List<DependencyCatalog>> execute() async {
    try {
      return await dependencycatalogRepo.getDependencies();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

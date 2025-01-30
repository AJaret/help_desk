import 'package:help_desk/internal/users/catalog/domain/entities/dependency.dart';
import 'package:help_desk/internal/users/catalog/domain/repositories/catalog_repository.dart';

class GetDependencyCatalogUseCase {
  final CatalogRepository dependencycatalogRepo;

  GetDependencyCatalogUseCase({required this.dependencycatalogRepo});

  Future<List<Catalog>> execute() async {
    try {
      return await dependencycatalogRepo.getDependencies();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

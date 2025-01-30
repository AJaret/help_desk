import 'package:help_desk/internal/users/catalog/domain/entities/dependency.dart';
import 'package:help_desk/internal/users/catalog/domain/repositories/catalog_repository.dart';

class GetPhysicalLocationsCatalogUseCase {
  final CatalogRepository dependencycatalogRepo;

  GetPhysicalLocationsCatalogUseCase({required this.dependencycatalogRepo});

  Future<List<Catalog>> execute() async {
    try {
      return await dependencycatalogRepo.getPhysicalLocations();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

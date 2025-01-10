import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/catalog/domain/entities/dependency.dart';
import 'package:help_desk/internal/catalog/domain/usecases/get_dependency_catalog_usecase.dart';
import 'package:help_desk/internal/catalog/domain/usecases/get_locations_catalog_usecase.dart';
import 'package:meta/meta.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {

  final GetDependencyCatalogUseCase getDependencyCatalogUseCase;
  final GetPhysicalLocationsCatalogUseCase getPhysicalLocationsCatalogUseCase;

  CatalogBloc({required this.getDependencyCatalogUseCase, required this.getPhysicalLocationsCatalogUseCase}) : super(CatalogInitial()) {
    on<GetDependencies>(_getDependencyCatalog);
    on<GetPhysicalLocations>(_getPhysicalLocationsCatalog);
  }

  Future<void> _getDependencyCatalog(GetDependencies event, Emitter<CatalogState> emit) async {
    try {
      emit(GettingCatalog());
      List<Catalog> data = await getDependencyCatalogUseCase.execute();
      emit(DependencyCatalogList(data));
    } catch (e) {
      emit(ErrorGettingDependencyCatalog(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }

  Future<void> _getPhysicalLocationsCatalog(GetPhysicalLocations event, Emitter<CatalogState> emit) async {
    try {
      emit(GettingCatalog());
      List<Catalog> data = await getPhysicalLocationsCatalogUseCase.execute();
      emit(PhysicalLocationsCatalogList(data));
    } catch (e) {
      emit(ErrorGettingPhysicalLocationsCatalog(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }
}

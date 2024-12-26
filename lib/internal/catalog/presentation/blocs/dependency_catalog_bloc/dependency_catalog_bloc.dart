import 'package:help_desk/internal/catalog/domain/entities/dependency.dart';
import 'package:help_desk/internal/catalog/domain/usecases/get_dependency_catalog_usecase.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dependency_catalog_event.dart';
part 'dependency_catalog_state.dart';

class DependencyCatalogBloc extends Bloc<DependencyCatalogEvent, DependencyCatalogState> {

  final GetDependencyCatalogUseCase getDependencyCatalogUseCase;

  DependencyCatalogBloc({required this.getDependencyCatalogUseCase}) : super(DependencyCatalogInitial()) {
    on<GetDependencies>(_getDependencyCatalog);
  }

  Future<void> _getDependencyCatalog(GetDependencies event, Emitter<DependencyCatalogState> emit) async {
    try {
      emit(GettingDependencyCatalog());
      List<DependencyCatalog> data = await getDependencyCatalogUseCase.execute();
      emit(DependencyCatalogList(data));
    } catch (e) {
      emit(ErrorGettingDependencyCatalog(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }
}

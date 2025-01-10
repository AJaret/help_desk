part of 'catalog_bloc.dart';

@immutable
sealed class CatalogState {}

final class CatalogInitial extends CatalogState {}

final class GettingCatalog extends CatalogState {}

final class DependencyCatalogList extends CatalogState {
  final List<Catalog> dependencyList;

  DependencyCatalogList(this.dependencyList);
}

final class ErrorGettingDependencyCatalog extends CatalogState{
  final String message;

  ErrorGettingDependencyCatalog(this.message);
}

final class PhysicalLocationsCatalogList extends CatalogState {
  final List<Catalog> locationsList;

  PhysicalLocationsCatalogList(this.locationsList);
}

final class ErrorGettingPhysicalLocationsCatalog extends CatalogState{
  final String message;

  ErrorGettingPhysicalLocationsCatalog(this.message);
}

part of 'dependency_catalog_bloc.dart';

@immutable
sealed class DependencyCatalogState {}

final class DependencyCatalogInitial extends DependencyCatalogState {}

final class GettingDependencyCatalog extends DependencyCatalogState {}

final class DependencyCatalogList extends DependencyCatalogState {
  final List<DependencyCatalog> dependencyList;

  DependencyCatalogList(this.dependencyList);
}

final class ErrorGettingDependencyCatalog extends DependencyCatalogState{
  final String message;

  ErrorGettingDependencyCatalog(this.message);
}

part of 'dependency_catalog_bloc.dart';

@immutable
sealed class DependencyCatalogEvent {}

class GetDependencies extends DependencyCatalogEvent{}

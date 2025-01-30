part of 'catalog_bloc.dart';

@immutable
sealed class CatalogEvent {}

class GetDependencies extends CatalogEvent{}

class GetPhysicalLocations extends CatalogEvent{}

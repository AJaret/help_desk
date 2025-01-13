import 'package:help_desk/internal/request/domain/entities/document.dart';

class NewRequest {
  final String? documentNumber;
  final String? serviceDescription;
  final String? observations;
  final String? inventoryNumber;
  final String? location;
  final String? physicalServiceLocation;
  final List<String>? phoneList;
  final List<String>? extensions;
  final List<String>? emails;
  final List<Document>? documents;

  NewRequest({
    this.documentNumber,
    this.serviceDescription,
    this.observations,  
    this.inventoryNumber,
    this.location,
    this.physicalServiceLocation,
    this.phoneList,
    this.extensions,
    this.emails,
    this.documents
  });
}
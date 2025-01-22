import 'package:help_desk/internal/request/domain/entities/document.dart';

class NewRequest {
  final String? documentNumber;
  final String? serviceDescription;
  final String? observations;
  final String? serviceLocation;
  final String? physicalServiceLocation;
  final String? addressWith;
  final List<String>? inventoryNumber;
  final List<String>? phoneList;
  final List<String>? extensions;
  final List<String>? emails;
  final List<Document>? documents;

  NewRequest({
    this.documentNumber,
    this.serviceDescription,
    this.observations,  
    this.serviceLocation,
    this.physicalServiceLocation,
    this.addressWith,
    this.inventoryNumber,
    this.phoneList,
    this.extensions,
    this.emails,
    this.documents
  });
}
import 'package:help_desk/internal/request/domain/entities/document.dart';

class NewRequest {
  final String? documentNumber;
  final String? serviceDescription;
  final String? observations;
  final String? serviceLocation;
  final String? physicalServiceLocation;
  final List<Map<String, dynamic>>? inventoryNumber;
  final List<Map<String, dynamic>>? phoneList;
  final List<Map<String, dynamic>>? extensions;
  final List<Map<String, dynamic>>? emails;
  final List<Document>? documents;

  NewRequest({
    this.documentNumber,
    this.serviceDescription,
    this.observations,  
    this.inventoryNumber,
    this.serviceLocation,
    this.physicalServiceLocation,
    this.phoneList,
    this.extensions,
    this.emails,
    this.documents
  });
}
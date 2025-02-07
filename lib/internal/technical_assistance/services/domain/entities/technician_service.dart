import 'package:help_desk/internal/technical_assistance/services/domain/entities/assigned_agent.dart';
import 'package:help_desk/internal/users/request/domain/entities/document.dart';
import 'package:help_desk/internal/users/request/domain/entities/follow_up.dart';

class TechnicianService {
  final int? idServicio;
  final String? date;
  final String? documentNumber;
  final String? dependency;
  final String? status;
  final String? requestFolio;
  final String? serviceFolio;
  final String? priority;
  final int? priorityId;

  final String? registrationDate;
  final String? employee;
  final String? serviceDescription;
  final String? observations;
  final String? location;
  final String? physicalLocation;
  final String? phone;
  final String? phoneExtension;
  final String? email;
  final String? applicant;
  final String? requestToken;
  final String? serviceToken;
  final String? inventoryNumber;
  final String? addressWith;
  final String? mainActivity;
  final String? serviceTitle;
  final String? registrationEmployee;
  final List<Document>? documents;
  final List<AssignedAgent>? assignedAgent;
  final List<FollowUp>? followUp;

  TechnicianService({
    this.idServicio,
    this.date,
    this.documentNumber,
    this.dependency,
    this.status,
    this.requestFolio,
    this.serviceFolio,
    this.priority,
    this.priorityId,
    this.registrationDate,
    this.employee,
    this.serviceDescription,
    this.observations,
    this.location,
    this.physicalLocation,
    this.phone,
    this.phoneExtension,
    this.email,
    this.applicant,
    this.requestToken,
    this.serviceTitle,
    this.inventoryNumber,
    this.addressWith,
    this.mainActivity,
    this.serviceToken,
    this.registrationEmployee,
    this.documents,
    this.assignedAgent,
    this.followUp
  });
}
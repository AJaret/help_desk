import 'dart:developer';

import 'package:help_desk/internal/request/domain/entities/document.dart';
import 'package:help_desk/internal/request/domain/entities/follow_up.dart';
import 'package:help_desk/internal/request/domain/entities/request.dart';

class RequestFull {
  final Request? requestDetails;
  final List<Document>? documents;
  final List<FollowUp>? followUps;
  final List<Service>? services;

  RequestFull({
    this.requestDetails,
    this.documents,
    this.followUps,
    this.services,
  });
}
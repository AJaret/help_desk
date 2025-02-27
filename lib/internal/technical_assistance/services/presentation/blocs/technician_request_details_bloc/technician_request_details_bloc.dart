import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/entities/technician_service.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/usecases/get_document_by_id_usecase.dart';
import 'package:help_desk/internal/technical_assistance/services/domain/usecases/get_technician_service_details_usecase.dart';
import 'package:help_desk/internal/users/request/domain/entities/document.dart';
import 'package:meta/meta.dart';

part 'technician_request_details_event.dart';
part 'technician_request_details_state.dart';

class TechnicianRequestDetailsBloc extends Bloc<TechnicianRequestDetailsEvent, TechnicianRequestDetailsState> {

  final GetTechnicianServiceDetailsUsecase getTechnicianServiceDetailsUsecase;
  final GetDocumentByIdUsecase getDocumentByIdUsecase;

  TechnicianRequestDetailsBloc(this.getTechnicianServiceDetailsUsecase, this.getDocumentByIdUsecase) : super(TechnicianRequestDetailsInitial()) {
    on<GetTechnicianRequestById>(_getTechnicianServiceDetails);
    on<GetTechnicianDocumentFile>(_getDocumentById);
  }

  Future<void> _getTechnicianServiceDetails(GetTechnicianRequestById event, Emitter<TechnicianRequestDetailsState> emit) async {
    emit(GettingTechnicianRequestDetails());
    try {
      final data = await getTechnicianServiceDetailsUsecase.execute(serviceId: event.requestId);
      emit(TechnicianRequestDetailsSuccess(data));
    } catch (e) {
      emit(ErrorGettingTechnicianRequestDetails(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }

  Future<void> _getDocumentById(GetTechnicianDocumentFile event, Emitter<TechnicianRequestDetailsState> emit) async {
    emit(GettingTechnicianDocumentFile());
    try {
      List<Document> documentsList = await Future.wait(
        event.documents.map((doc) => getDocumentByIdUsecase.execute(documentId: doc.documentId ?? 0))
      );

      emit(TechnicianDocumentFileSuccess(documentsList));
    } catch (e) {
      emit(ErrorGettingTechnicianDocumentFile(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }
}

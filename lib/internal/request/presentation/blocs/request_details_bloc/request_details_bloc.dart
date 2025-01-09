import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/request/domain/entities/document.dart';
import 'package:help_desk/internal/request/domain/entities/request_full.dart';
import 'package:help_desk/internal/request/domain/usecases/get_document_file_usecase.dart';
import 'package:help_desk/internal/request/domain/usecases/get_request_by_id_usecase.dart';
import 'package:meta/meta.dart';

part 'request_details_event.dart';
part 'request_details_state.dart';

class RequestDetailsBloc extends Bloc<RequestDetailsEvent, RequestDetailsState> {

  final GetRequestByIdUsecase getRequestByIdUsecase;
  final GetDocumentFileUsecase getDocumentFile;

  RequestDetailsBloc(this.getRequestByIdUsecase, this.getDocumentFile) : super(RequestDetailsInitial()) {
    on<GetRequestById>(_getRequestById);
    on<GetDocumentFile>(_getDocumentFile);
  }

  Future<void> _getRequestById(GetRequestById event, Emitter<RequestDetailsState> emit) async {
    emit(GettingRequestDetails());
    try {
      final data = await getRequestByIdUsecase.execute(requestId: event.requestId);
      emit(RequestDetailsSuccess(data));
    } catch (e) {
      emit(ErrorGettingRequestDetails(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }

  Future<void> _getDocumentFile(GetDocumentFile event, Emitter<RequestDetailsState> emit) async {
    emit(GettingDocumentFile());
    try {
      final data = await getDocumentFile.execute(documentId: event.documentId);
      emit(DocumentFileSuccess(data));
    } catch (e) {
      emit(ErrorGettingDocumentFile(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }
}

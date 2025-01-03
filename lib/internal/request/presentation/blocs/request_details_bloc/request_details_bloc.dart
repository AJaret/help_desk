import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/request/domain/entities/request_full.dart';
import 'package:help_desk/internal/request/domain/usecases/get_request_by_id_usecase.dart';
import 'package:meta/meta.dart';

part 'request_details_event.dart';
part 'request_details_state.dart';

class RequestDetailsBloc extends Bloc<RequestDetailsEvent, RequestDetailsState> {

  final GetRequestByIdUsecase getRequestByIdUsecase;

  RequestDetailsBloc(this.getRequestByIdUsecase) : super(RequestDetailsInitial()) {
    on<GetRequestById>(_getRequestById);
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
}

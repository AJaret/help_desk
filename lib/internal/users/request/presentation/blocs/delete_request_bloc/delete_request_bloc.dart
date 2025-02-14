import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/users/request/domain/usecases/delete_request_usecase.dart';
import 'package:meta/meta.dart';

part 'delete_request_event.dart';
part 'delete_request_state.dart';

class DeleteRequestBloc extends Bloc<DeleteRequestEvent, DeleteRequestState> {
  final DeleteRequestUsecase deleteRequestUsecase;

  DeleteRequestBloc(this.deleteRequestUsecase) : super(DeleteRequestInitial()) {
    on<DeleteRequest>(_deleteRequest);
  }
  
  Future<void> _deleteRequest(DeleteRequest event, Emitter<DeleteRequestState> emit) async {
    emit(DeletingRequest());
    try {
      await deleteRequestUsecase.execute(requestId: event.requestId);
      emit(DeleteRequestSuccess());
    } catch (e) {
      emit(ErrorDeletingRequest(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }
}

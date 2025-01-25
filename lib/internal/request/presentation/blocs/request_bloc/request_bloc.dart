import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/request/domain/entities/new_request.dart';
import 'package:help_desk/internal/request/domain/entities/request.dart';
import 'package:help_desk/internal/request/domain/usecases/delete_request_usecase.dart';
import 'package:help_desk/internal/request/domain/usecases/post_new_request_usecase.dart';
import 'package:help_desk/internal/request/domain/usecases/post_request_usecase.dart';
import 'package:meta/meta.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {

  final PostRequestUsecase postRequestUseCase;
  final PostNewRequestUsecase postNewRequestUsecase;
  final DeleteRequestUsecase deleteRequestUsecase;

  RequestBloc(this.postRequestUseCase, this.postNewRequestUsecase, this.deleteRequestUsecase) : super(RequestInitial()) {
    on<GetRequests>(_getRequests);
    on<PostNewRequest>(_postRequest);
    on<DeleteRequest>(_deleteRequest);
  }

  Future<void> _getRequests(GetRequests event, Emitter<RequestState> emit) async {
    emit(GettingRequests());
    try {
      final data = await postRequestUseCase.execute();
      emit(GetRequestSuccess(data));
    } catch (e) {
      emit(ErrorGettingRequests(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }

  Future<void> _postRequest(PostNewRequest event, Emitter<RequestState> emit) async {
    emit(PostingNewRequest());
    try {
      final data = await postNewRequestUsecase.execute(requestData: event.requestData);
      emit(PostRequestSuccess(data));
    } catch (e) {
      emit(ErrorPostingRequest(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }

  Future<void> _deleteRequest(DeleteRequest event, Emitter<RequestState> emit) async {
    emit(DeletingRequest());
    try {
      await deleteRequestUsecase.execute(requestId: event.requestId);
      emit(DeleteRequestSuccess());
      add(GetRequests());
    } catch (e) {
      emit(ErrorDeletingRequest(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }
}

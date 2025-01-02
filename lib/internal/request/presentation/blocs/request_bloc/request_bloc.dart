import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/request/domain/entities/request.dart';
import 'package:help_desk/internal/request/domain/usecases/get_request_usecase.dart';
import 'package:meta/meta.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {

  final PostRequestUsecase postRequestUseCase;

  RequestBloc(this.postRequestUseCase) : super(RequestInitial()) {
    on<PostRequest>(_postRequest);
  }

  Future<void> _postRequest(PostRequest event, Emitter<RequestState> emit) async {
    emit(PostingRequest());
    try {
      final data = await postRequestUseCase.execute();
      emit(RequestSuccess(data));
    } catch (e) {
      emit(ErrorPostingRequest(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }
}

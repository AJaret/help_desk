import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/login/domain/usecases/post_login_usecase.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  final PostLoginUseCase postLoginUseCase;

  LoginBloc(this.postLoginUseCase) : super(LoginInitial()) {
    on<PostLogin>(_postUserLogin);
  }

  Future<void> _postUserLogin(PostLogin event, Emitter<LoginState> emit) async {
    emit(PostingLogin());
    try {
      await postLoginUseCase.execute(email: event.email, password: event.password);
      emit(LoginSuccess());
    } catch (e) {
      emit(ErrorPostingLogin(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }
}

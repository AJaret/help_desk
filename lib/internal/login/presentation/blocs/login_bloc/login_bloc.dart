import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/login/domain/usecases/post_login_usecase.dart';
import 'package:help_desk/internal/login/domain/usecases/post_reset_password_usecase.dart';
import 'package:help_desk/shared/services/token_service.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final PostLoginUseCase postLoginUseCase;
  final PostResetPasswordUseCase postResetPassword;
  final TokenService tokenService = TokenService();

  LoginBloc(this.postLoginUseCase, this.postResetPassword) : super(LoginInitial()) {
    on<PostLogin>(_postUserLogin);
    on<Logout>(_logoutUser);
    on<PostResetPassword>(_postResetPassword);
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

  Future<void> _logoutUser(Logout event, Emitter<LoginState> emit) async {
    await tokenService.logout();
    emit(Unauthenticated());
  }

  Future<void> _postResetPassword(PostResetPassword event, Emitter<LoginState> emit) async {
    emit(PostingResetPassword());
    try {
      await postResetPassword.execute(email: event.email, employeeNumber: event.employeeNumber);
      emit(ResetPasswordSuccess());
    } catch (e) {
      emit(ErrorPostingResetPassword(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }
}

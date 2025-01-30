import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help_desk/internal/technical_assistance/login/domain/usecases/post_technicians_login_usecase.dart';
import 'package:help_desk/shared/services/token_service.dart';
import 'package:meta/meta.dart';

part 'technical_assistance_login_event.dart';
part 'technical_assistance_login_state.dart';

class TechnicalAssistanceLoginBloc extends Bloc<TechnicalAssistanceLoginEvent, TechnicalAssistanceLoginState> {
  final PostTechniciansLoginUsecase postTechniciansLoginUsecase;
  final TokenService tokenService = TokenService();

  TechnicalAssistanceLoginBloc(this.postTechniciansLoginUsecase) : super(TechnicalAssistanceLoginInitial()) {
    on<PostTechnicalAssistanceLogin>(_posTechnicalAssistanceLogin);
    on<TechnicalAssistanceLogout>(_logoutUser);
  }

  Future<void> _posTechnicalAssistanceLogin(PostTechnicalAssistanceLogin event, Emitter<TechnicalAssistanceLoginState> emit) async {
    emit(PostingTechnicalAssistanceLogin());
    try {
      await postTechniciansLoginUsecase.execute(email: event.email, password: event.password);
      emit(TechnicalAssistanceLoginSuccess());
    } catch (e) {
      emit(ErrorPostingTechnicalAssistanceLogin(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }

  Future<void> _logoutUser(TechnicalAssistanceLogout event, Emitter<TechnicalAssistanceLoginState> emit) async {
    await tokenService.logout();
    emit(TechnicalAssistanceUnauthenticated());
  }
}

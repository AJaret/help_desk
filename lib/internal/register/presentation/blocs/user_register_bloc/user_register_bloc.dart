import 'package:help_desk/internal/register/domain/entities/user_register.dart';
import 'package:help_desk/internal/register/domain/usecases/post_user_usecase.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_register_event.dart';
part 'user_register_state.dart';

class UserRegisterBloc extends Bloc<UserRegisterEvent, UserRegisterState> {

  final PostUserRegisterUseCase postUserRegisterUseCase;

  UserRegisterBloc({required this.postUserRegisterUseCase}) : super(UserRegisterInitial()) {
    on<PostUserRegister>(_postUserRegister);
  }

  Future<void> _postUserRegister(PostUserRegister event, Emitter<UserRegisterState> emit) async {
    try {
      emit(PostingUserRegister());
      bool data = await postUserRegisterUseCase.execute(userData: event.userData);
      emit(UserRegisterPosted(data));
    } catch (e) {
      emit(ErrorPostingUserRegister(e.toString().replaceAll(RegExp(r"Exception:"), "").trimLeft()));
    }
  }
}

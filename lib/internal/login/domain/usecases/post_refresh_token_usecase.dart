// import 'package:help_desk/internal/login/domain/entities/session.dart';
// import 'package:help_desk/internal/login/domain/repositories/login_repository.dart';

// class PostRefreshTokenUseCase {
//   final LoginRepository userLoginRepo;

//   PostRefreshTokenUseCase({required this.userLoginRepo});

//   Future<Session> execute({required String refreshToken}) async {
//     try {
//       return await userLoginRepo.postRefreshToken(refreshToken);
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }
// }
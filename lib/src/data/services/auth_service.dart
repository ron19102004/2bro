import 'package:app_chat/src/data/entities/user_entity.dart';
import 'package:app_chat/src/data/repositories/auth_repo.dart';
import 'package:app_chat/src/data/repositories/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {
  Future<bool> signInWithGoogle();
}

class AuthServiceImpl implements AuthService {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  AuthServiceImpl({required this.authRepository, required this.userRepository});

  @override
  Future<bool> signInWithGoogle() async {
    UserCredential userCredential = await authRepository.signInWithGoogle();
    if (userCredential.user == null) {
      return false;
    }
    User user = userCredential.user!;
    UserEntity userEntity = UserEntity.fromUserAuth(user);
    await userRepository.save(userEntity);
    return true;
  }
}

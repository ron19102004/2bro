import 'package:app_chat/src/data/repositories/auth_repo.dart';
import 'package:app_chat/src/data/repositories/message_repo.dart';
import 'package:app_chat/src/data/repositories/user_repo.dart';
import 'package:app_chat/src/data/services/auth_service.dart';
import 'package:app_chat/src/data/services/message_service.dart';
import 'package:get_it/get_it.dart';

final di = GetIt.instance;

Future<void> initializeDependencies() async {
  //repositories
  di.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  di.registerSingleton<UserRepository>(UserRepositoryImpl());
  di.registerSingleton<MessageRepository>(MessageRepositoryImpl());
  //services
  di.registerSingleton<AuthService>(
      AuthServiceImpl(authRepository: di(), userRepository: di()));
  di.registerSingleton<MessageService>(
      MessageServiceImpl(messageRepository: di(), userRepository: di()));
}

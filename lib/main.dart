import 'package:app_chat/core/configs/dependencies_injection.dart';
import 'package:app_chat/src/presentation/screens/start_point_app_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDependencies();
  runApp(const StartPointAppScreen());
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'core/auth_service.dart';
import 'app.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Provide firebase_options.dart via `flutterfire configure`, then:
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   final authService = AuthService()..init();
  runApp(
    ChangeNotifierProvider.value(
      value: authService,
      child: const TraumaTraceApp(),
    ),
  );
}

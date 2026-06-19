import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trauma/features/home/splashscreen.dart';
import 'core/auth_service.dart';
import 'shell/main_shell.dart';

const kSeed = Color(0xFF5B7B7A); // calm muted teal

class TraumaTraceApp extends StatelessWidget {
  const TraumaTraceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TraumaTrace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: kSeed),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F5F1),
      ),
      home: Consumer<AuthService>(
        builder: (context, auth, _) {
          if (!auth.ready) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          return auth.isSignedIn ? const MainShell() : const SplashScreen();
        },
      ),
    );
  }
}

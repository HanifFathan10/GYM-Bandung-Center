import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'ui/page/login_page.dart';
import 'ui/page/dashboard_page.dart';
import 'helpers/theme_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GYM Bandung Center',
      theme: AppTheme.darkTheme,
      home: const SessionCheck(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SessionCheck extends StatelessWidget {
  const SessionCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Tampilkan loading saat mengecek token
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: AppTheme.bgDark,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Jika user memiliki token aktif, masuk Dashboard. Jika tidak, Login.
        if (snapshot.hasData) {
          return const DashboardPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}

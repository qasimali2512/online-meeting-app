import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:zoom/Screen/auth/forgot_password_screen.dart';
import 'package:zoom/Screen/home_screen.dart';
import 'package:zoom/Screen/auth/login_screen.dart';
import 'package:zoom/Screen/auth/otp_screen.dart';
import 'package:zoom/Screen/meeting/schedule_meeting_screen.dart';
import 'package:zoom/Screen/meeting/share_screen_screen.dart';
import 'package:zoom/Screen/auth/sign_up_screen.dart';
import 'package:zoom/Screen/splash.dart';
import 'package:zoom/Screen/meeting/join_meeting_Screen.dart';
import 'package:zoom/color.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDlsAbFQRWYac-4wlxYab8l5XLhvEcNtD8",
        authDomain: "zoom-project-fbe53.firebaseapp.com",
        projectId: "zoom-project-fbe53",
        storageBucket: "zoom-project-fbe53.appspot.com",
        messagingSenderId: "10415281313",
        appId: "1:10415281313:web:fd72bae5a31ab91e880ce0",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zoom Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/video-call': (context) => const VideoCallScreen(),
        '/forgot': (context) => const ForgotPasswordScreen(),
        '/otp': (context) => const OtpVerificationScreen(),
        '/schedule': (context) => const ScheduleMeetingScreen(),
        '/share-screen': (context) => const ShareScreenScreen(),
      },
    );
  }
}

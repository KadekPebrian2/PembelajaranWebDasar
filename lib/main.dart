import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// PENTING: Mengimpor file konfigurasi Firebase bawaan proyekmu
import 'firebase_options.dart'; 

// Import Halaman
import 'views/auth/login_screen.dart'; 

// Import Providers
import 'providers/auth_provider.dart';
import 'providers/course_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  // 1. Pastikan binding Flutter siap
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // 2. Inisialisasi Firebase dengan menyertakan opsi platform (Web/Android)
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase Berhasil Terhubung dengan Konfigurasi yang Benar!");
  } catch (e) {
    debugPrint("Firebase Error saat inisialisasi: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => CourseProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MaterialApp(
        title: 'WebLearn PBL',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const LoginScreen(), 
      ),
    );
  }
}
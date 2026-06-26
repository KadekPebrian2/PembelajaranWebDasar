import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart'; 
import 'views/auth/login_screen.dart'; 

import 'providers/auth_provider.dart';
import 'providers/course_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
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
      // 🔥 KUNCI UTAMA: Consumer membaca state dari ThemeProvider secara live
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'WebLearn PBL',
            debugShowCheckedModeBanner: false,
            
            // 1. Menyuruh MaterialApp ikut saklar dari ThemeProvider
            themeMode: themeProvider.themeMode,

            // 2. SETELAN BAJU MODE TERANG (LIGHT)
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFF9FAFC),
              cardColor: Colors.white,
              dividerColor: const Color(0xFFE2E8F0),
              colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8200E6)),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Color(0xFF0F172A)), 
                bodyMedium: TextStyle(color: Color(0xFF334155)),
                bodySmall: TextStyle(color: Color(0xFF64748B)),
              ),
            ),

            // 3. SETELAN BAJU MODE GELAP (DARK)
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900 (Gelap Elegan)
              cardColor: const Color(0xFF1E293B),               // Slate 800 (Warna Kartu)
              dividerColor: const Color(0xFF334155),            // Slate 700
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF8200E6),
                brightness: Brightness.dark,
              ),
              textTheme: const TextTheme(
                bodyLarge: TextStyle(color: Color(0xFFF8FAFC)), // Putih Terang
                bodyMedium: TextStyle(color: Color(0xFFE2E8F0)),
                bodySmall: TextStyle(color: Color(0xFF94A3B8)),
              ),
            ),

            home: const LoginScreen(), 
          );
        },
      ),
    );
  }
}
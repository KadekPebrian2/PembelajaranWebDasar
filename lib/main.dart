import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'core/theme.dart';
import 'providers/auth_provider.dart';
import 'providers/course_provider.dart';
import 'providers/theme_provider.dart';
import 'views/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Perbaikan Error: Inisialisasi Database untuk Windows/Linux/Mac
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), 
      ],
      child: const WebLearnApp(),
    ),
  );
}

class WebLearnApp extends StatelessWidget {
  const WebLearnApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'WebLearn',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode, 
      home: LoginScreen(), // Memulai dari Login
    );
  }
}
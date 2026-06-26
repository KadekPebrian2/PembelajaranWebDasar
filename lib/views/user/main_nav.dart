import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/theme_provider.dart';
import 'home_screen.dart';
import 'materi_screen.dart';
import 'quiz_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _pages = [HomeScreen(), MateriScreen(), QuizScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    // Sinkronisasi warna bar navigasi bawah dengan Dark Mode
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppTheme.primaryPurple,
        unselectedItemColor: isDark ? const Color(0xFF94A3B8) : Colors.grey,
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'Materi'),
          BottomNavigationBarItem(icon: Icon(Icons.quiz_rounded), label: 'Quiz'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}
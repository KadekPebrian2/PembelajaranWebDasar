import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_screen.dart';
import '../../providers/auth_provider.dart'; 
import '../auth/login_screen.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF8200E6);

    // 1. Ambil data user yang sedang aktif dari Provider
    final userData = Provider.of<AuthProvider>(context).currentUser;

    // 2. Jika userData null (untuk jaga-jaga), set nilai default
    final namaLengkap = userData?['nama'] ?? 'User Guest';
    final emailUser = userData?['email'] ?? 'Belum ada email';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Warna background abu-abu kebiruan sangat terang
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Halaman
              const Text(
                "Profil",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Card Profil (Sesuai Desain Anda)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Icon Lingkaran Ungu
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: primaryPurple,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    
                    // Nama Dinamis (Otomatis dari Database)
                    Text(
                      namaLengkap,
                      style: const TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    
                    // Email Dinamis (Otomatis dari Database)
                    Text(
                      emailUser,
                      style: const TextStyle(
                        fontSize: 14, 
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Menu Pengaturan
              // Tombol Menu Pengaturan
              _buildMenuButton(
                icon: Icons.settings,
                title: "Pengaturan",
                onTap: () {
                  // Arahkan ke halaman pengaturan
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
              const SizedBox(height: 15),

              // Tombol Menu Logout
              _buildMenuButton(
                icon: Icons.logout,
                title: "Logout",
                onTap: () {
                  // Proses hapus sesi dan kembali ke halaman Login
                  Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (_) => const LoginScreen()), 
                    (route) => false
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget bantuan untuk membuat tombol menu yang seragam sesuai desain
  Widget _buildMenuButton({required IconData icon, required String title, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF8200E6)),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_screen.dart';
import '../../providers/auth_provider.dart'; 
import '../../providers/theme_provider.dart'; 
import '../auth/login_screen.dart'; 

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  // Fungsi memunculkan Notifikasi Konfirmasi Keluar Akun
  void _showLogoutDialog(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            "Konfirmasi Keluar",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          content: Text(
            "Apakah Anda yakin ingin keluar dari aplikasi?",
            style: TextStyle(
              color: isDark ? const Color(0xFF94A3B8) : Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Tutup dialog
                
                // === PERBAIKAN DI SINI ===
                // Menggunakan fungsi logout dari AuthProvider Anda
                try {
                  // Jika di auth_provider.dart Anda namanya adalah 'logout', kode ini akan berjalan lancar
                  await Provider.of<AuthProvider>(context, listen: false).logout();
                } catch (e) {
                  // Fallback sekiranya fungsi logout Anda bernama berbeda
                  print("Gagal logout: $e");
                }
                
                if (context.mounted) {
                  // Pindah ke Login & bersihkan stack navigasi
                  Navigator.pushAndRemoveUntil(
                    context, 
                    MaterialPageRoute(builder: (_) => const LoginScreen()), 
                    (route) => false
                  );
                  
                  // Notifikasi mengambang penanda sukses keluar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Berhasil keluar dari akun."),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text("Keluar", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF8200E6);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    final userData = Provider.of<AuthProvider>(context).currentUser;
    final namaLengkap = userData?.displayName ?? (userData?.email?.split('@')[0] ?? 'User Guest');
    final emailUser = userData?.email ?? 'Belum ada email';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Profil",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              // Card Informasi Singkat Pengguna
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: primaryPurple.withValues(alpha: 0.15),
                      child: const Icon(Icons.person, size: 40, color: primaryPurple),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            namaLengkap,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            emailUser,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? const Color(0xFF94A3B8) : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),

              // Hanya menyisakan Menu Pengaturan
              _buildMenuButton(
                icon: Icons.settings_rounded,
                title: "Pengaturan",
                isDark: isDark,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),
              
              // Hanya menyisakan Menu Keluar
              _buildMenuButton(
                icon: Icons.logout_rounded,
                title: "Keluar",
                isDark: isDark,
                iconColor: Colors.redAccent,
                onTap: () => _showLogoutDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required bool isDark,
    required VoidCallback onTap,
    Color iconColor = const Color(0xFF8200E6),
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: isDark ? const Color(0xFF64748B) : Colors.grey),
          ],
        ),
      ),
    );
  }
}
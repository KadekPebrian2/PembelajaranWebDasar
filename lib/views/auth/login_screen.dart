import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'register_screen.dart';
import '../main_screen.dart';
import '../admin/admin_dashboard.dart';
import '../../providers/auth_provider.dart'; 
import '../../providers/theme_provider.dart'; // <-- 1. Tambah pemanggil tema

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLoading = false; // Efek loading saat menekan tombol

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF8200E6);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode; // <-- 2. Cek tema aktif

    return Scaffold(
      // <-- 3. Latar belakang dinamis (Gelap malam / Putih bersih)
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Ungu (100% Tidak Diubah)
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: primaryPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            color: Color(0x1AFFFFFF),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Image.asset(
                          'assets/images/Gambar2.png',
                          height: 260,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Selamat Datang",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Masuk Untuk Melanjutkan Belajar",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ),

            // Form Input & Tombol
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _emailCtrl,
                    hint: "Email",
                    icon: Icons.email_outlined,
                    isPassword: false,
                    isDark: isDark, // <-- Kirim status tema ke inputan
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _passCtrl,
                    hint: "Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 40),

                  // Tombol Masuk
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3, 
                      ),
                      onPressed: _isLoading ? null : () async {
                        String email = _emailCtrl.text.trim();
                        String password = _passCtrl.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Email dan Password tidak boleh kosong!"), backgroundColor: Colors.red),
                          );
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                        });

                        final authProvider = Provider.of<AuthProvider>(context, listen: false);
                        final user = await authProvider.loginWithFirebase(email, password);

                        setState(() {
                          _isLoading = false;
                        });

                        if (!mounted) return;

                        if (user != null) {
                          if (user['role'] == 'admin') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => AdminDashboard()),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => MainScreen()),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Email/Password salah atau koneksi internet terganggu!"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Masuk",
                            style: TextStyle(
                              color: Colors.white, 
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Teks Daftar Akun
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Belum punya akun? ", style: TextStyle(fontSize: 15, color: isDark ? const Color(0xFF94A3B8) : Colors.black87)), // <-- Warna teks bawah dinamis
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => RegisterScreen()),
                          );
                        },
                        child: const Text(
                          "Daftar",
                          style: TextStyle(color: primaryPurple, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isPassword,
    required bool isDark, // <-- Parameter tema baru
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF9FAFB), // <-- Kotak input dinamis
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? const Color(0xFF334155) : Colors.black12), 
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87), // <-- KUNCI: Warna ketikan dinamis
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : Colors.black38, fontSize: 15),
          prefixIcon: Icon(icon, color: isDark ? const Color(0xFF94A3B8) : Colors.black45, size: 24),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
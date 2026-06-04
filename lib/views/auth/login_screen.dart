import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'register_screen.dart';
import '../main_screen.dart';
import '../admin/admin_dashboard.dart';
import '../../core/database_helper.dart'; 
import '../../providers/auth_provider.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF8200E6);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Ungu
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
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _passCtrl,
                    hint: "Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
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
                      onPressed: () async {
                        String email = _emailCtrl.text.trim();
                        String password = _passCtrl.text.trim();

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Email dan Password tidak boleh kosong!"), backgroundColor: Colors.red),
                          );
                          return;
                        }

                        // Cek ke Database SQLite
                        final user = await DatabaseHelper.instance.loginUser(email, password);

                        if (!mounted) return;

                        if (user != null) {
                          // Simpan data user ke Provider
                          Provider.of<AuthProvider>(context, listen: false).login(user);

                          // Cek Role
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
                              content: Text("Akun tidak ditemukan atau Password salah. Silakan Daftar!"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        }
                      },
                      child: const Text(
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
                      const Text("Belum punya akun? ", style: TextStyle(fontSize: 15)),
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB), 
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12), 
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 15),
          prefixIcon: Icon(icon, color: Colors.black45, size: 24),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../../core/theme.dart';
import '../../providers/auth_provider.dart'; 
import '../../providers/theme_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key); 

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _namaCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _isLoading = false; 

  @override
  void dispose() {
    _namaCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Ungu Senada dengan Login
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppTheme.primaryPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.person_add_alt_1, size: 80, color: Colors.white),
                    SizedBox(height: 15),
                    Text(
                      "Buat Akun Baru",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Lengkapi data untuk mendaftar",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            // Form Registrasi
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  _buildTextField("Nama Lengkap", Icons.person, _namaCtrl, false, isDark),
                  const SizedBox(height: 15),
                  _buildTextField("Email", Icons.email, _emailCtrl, false, isDark),
                  const SizedBox(height: 15),
                  _buildTextField("Password", Icons.lock, _passCtrl, true, isDark),
                  const SizedBox(height: 15),
                  _buildTextField("Konfirmasi Password", Icons.lock_outline, _confirmPassCtrl, true, isDark),
                  const SizedBox(height: 30),

                  // Tombol Daftar
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryPurple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                      onPressed: _isLoading ? null : () async {
                        String nama = _namaCtrl.text.trim();
                        String email = _emailCtrl.text.trim();
                        String password = _passCtrl.text.trim();
                        String confirmPassword = _confirmPassCtrl.text.trim();

                        if (nama.isEmpty || email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Semua kolom harus diisi!"),
                                backgroundColor: Colors.red),
                          );
                          return;
                        }

                        final emailRegex = RegExp(
                            r'^[\w-\.]+@(gmail\.com|yahoo\.com|yahoo\.co\.id|outlook\.com|hotmail\.com)$',
                            caseSensitive: false);
                        if (!emailRegex.hasMatch(email)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Pendaftaran hanya mendukung email publik! (Gmail, Yahoo, atau Outlook)"),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        if (password.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Kata sandi terlalu pendek! Minimal harus 6 karakter."),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }

                        if (password != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Password tidak cocok!"),
                                backgroundColor: Colors.red),
                          );
                          return;
                        }

                        setState(() {
                          _isLoading = true;
                        });

                        try {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          
                          // 🔥 SELESAI DISESUAIKAN: Sekarang mengirimkan data 'nama' ke AuthProvider
                          bool isSuccess = await authProvider.registerWithFirebase(email, password, nama);

                          setState(() {
                            _isLoading = false;
                          });

                          if (!mounted) return;

                          if (isSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Pendaftaran Berhasil! Silakan Login."),
                                  backgroundColor: Colors.green),
                            );

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Email sudah terdaftar atau format salah! Gunakan email lain."),
                                  backgroundColor: Colors.red),
                            );
                          }
                        } catch (e) {
                          setState(() {
                            _isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Terjadi kesalahan sistem: $e"),
                                backgroundColor: Colors.red),
                          );
                        }
                      },
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Daftar",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Tombol Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sudah punya akun? ", style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : Colors.black87)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()));
                        },
                        child: const Text("Masuk",
                            style: TextStyle(
                                color: AppTheme.primaryPurple,
                                fontWeight: FontWeight.bold)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, IconData icon, TextEditingController controller, bool isPassword, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF9FAFB), 
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? const Color(0xFF334155) : Colors.black12),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87), 
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: isDark ? const Color(0xFF64748B) : Colors.black38),
          prefixIcon: Icon(icon, color: isDark ? const Color(0xFF94A3B8) : Colors.black54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
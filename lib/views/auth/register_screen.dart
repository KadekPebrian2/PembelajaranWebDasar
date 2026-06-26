import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // <-- Tambahkan import ini
import '../../core/theme.dart';
import '../../providers/auth_provider.dart'; // <-- Tambahkan import ini
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key); // Ditambahkan const constructor agar rapi

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _namaCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _isLoading = false; // Efek loading saat proses daftar berlangsung

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
    return Scaffold(
      backgroundColor: Colors.white,
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
                  _buildTextField(
                      "Nama Lengkap", Icons.person, _namaCtrl, false),
                  const SizedBox(height: 15),
                  _buildTextField("Email", Icons.email, _emailCtrl, false),
                  const SizedBox(height: 15),
                  _buildTextField("Password", Icons.lock, _passCtrl, true),
                  const SizedBox(height: 15),
                  _buildTextField("Konfirmasi Password", Icons.lock_outline,
                      _confirmPassCtrl, true),
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

                        // 1. Validasi Kolom Kosong
                        if (nama.isEmpty || email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Semua kolom harus diisi!"),
                                backgroundColor: Colors.red),
                          );
                          return;
                        }

                        // 2. Validasi Format Email Publik
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

                        // 3. Validasi Panjang Minimal Password
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

                        // 4. Validasi Konfirmasi Password
                        if (password != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Password tidak cocok!"),
                                backgroundColor: Colors.red),
                          );
                          return;
                        }

                        // Nyalakan efek loading spinner
                        setState(() {
                          _isLoading = true;
                        });

                        // AKSI BARU: Daftarkan langsung ke Server Firebase Auth lewat Provider
                        try {
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          bool isSuccess = await authProvider.registerWithFirebase(email, password);

                          // Matikan efek loading spinner
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

                            // Arahkan kembali ke halaman Login
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()));
                          } else {
                            // Gagal mendaftar dari sisi Firebase (biasanya karena email duplikat)
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

                  // Tombol Login (Jika sudah punya akun)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sudah punya akun? "),
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

  // Widget bantuan untuk TextField
  Widget _buildTextField(String hint, IconData icon,
      TextEditingController controller, bool isPassword) {
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
          prefixIcon: Icon(icon, color: Colors.black54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
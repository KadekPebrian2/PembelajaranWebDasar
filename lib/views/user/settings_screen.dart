import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Variabel untuk menyimpan status Dark Mode (sementara hanya untuk UI)
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF8200E6);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Background abu-abu sangat terang
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryPurple),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman profil
          },
        ),
        title: const Text(
          "Pengaturan",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Label UMUM
            const Text(
              "UMUM",
              style: TextStyle(
                color: primaryPurple,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2, // Memberi jarak antar huruf agar mirip desain
              ),
            ),
            const SizedBox(height: 15),

            // Card Putih berisi Menu
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                  // Menu 1: Tentang Aplikasi
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: CircleAvatar(
                      backgroundColor: primaryPurple.withValues(alpha: 0.1),
                      child: const Icon(Icons.info_outline, color: primaryPurple),
                    ),
                    title: const Text(
                      "Tentang Aplikasi",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: primaryPurple),
                    onTap: () {
                      // Munculkan Pop-up informasi aplikasi saat diklik
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          title: const Text("Tentang Aplikasi", style: TextStyle(color: primaryPurple)),
                          content: const Text("Aplikasi WebLearn v1.0\nDibuat untuk pembelajaran yang lebih mudah dan menyenangkan."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Tutup", style: TextStyle(color: primaryPurple)),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  
                  // Garis pemisah tipis
                  Divider(height: 1, color: Colors.grey.shade200, indent: 20, endIndent: 20),

                  // Menu 2: Dark Mode
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    leading: CircleAvatar(
                      backgroundColor: primaryPurple.withValues(alpha: 0.1),
                      child: const Icon(Icons.dark_mode, color: primaryPurple),
                    ),
                    title: const Text(
                      "Dark Mode",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                    ),
                    trailing: Switch(
                      value: isDarkMode,
                      activeColor: Colors.white,
                      activeTrackColor: primaryPurple,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey.shade300,
                      onChanged: (bool value) {
                        setState(() {
                          isDarkMode = value;
                        });
                        // NOTE: Ini baru mengubah UI switch-nya saja. 
                        // Untuk mengubah tema seluruh aplikasi menjadi gelap, 
                        // Anda perlu mengaturnya di Provider/MaterialApp.
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
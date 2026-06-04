import 'package:flutter/material.dart';

// IMPORT SUDAH DIPERBAIKI SESUAI FOLDER
import '../materi/html_materi_screen.dart';
import '../materi/css_materi_screen.dart';
import '../materi/js_materi_screen.dart';

class MateriScreen extends StatelessWidget {
  const MateriScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Warna ungu utama sesuai dengan tema desain Anda
    const primaryPurple = Color(0xFF8200E6);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Latar belakang abu-abu sangat terang
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul Halaman Atas
              const Text(
                "Materi Pembelajaran",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 25),

              // 1. CARD MATERI HTML
              _buildMenuMateri(
                context: context,
                badgeText: "HTML",
                title: "HTML",
                subtitle: "Belajar dasar struktur website",
                badgeColor: primaryPurple.withValues(alpha: 0.1),
                textColor: primaryPurple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HtmlMateriScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // 2. CARD MATERI CSS
              _buildMenuMateri(
                context: context,
                badgeText: "CSS",
                title: "CSS",
                subtitle: "Belajar styling dan layouting",
                badgeColor: primaryPurple.withValues(alpha: 0.1),
                textColor: primaryPurple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CssMateriScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // 3. CARD MATERI JAVASCRIPT
              _buildMenuMateri(
                context: context,
                badgeText: "JS",
                title: "JavaScript",
                subtitle: "Belajar interaktivitas website",
                badgeColor: primaryPurple.withValues(alpha: 0.1),
                textColor: primaryPurple,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const JsMateriScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Kustom Pembuat Card Menu agar tampilan konsisten dan rapi
  Widget _buildMenuMateri({
    required BuildContext context,
    required String badgeText,
    required String title,
    required String subtitle,
    required Color badgeColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap, // Memicu perpindahan halaman saat kartu ditekan
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
            child: Row(
              children: [
                // Kotak Badge Sebelah Kiri (HTML / CSS / JS)
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                
                // Teks Judul dan Subtitle Tengah
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Panah Chevron Kanan
                const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
// PERBAIKAN IMPORT: Ditambahkan '../' karena file ini berada di dalam folder 'user'
import '../materi/html_materi_screen.dart';
import '../materi/css_materi_screen.dart';
import '../materi/js_materi_screen.dart';

class MateriScreen extends StatelessWidget {
  const MateriScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Materi Pembelajaran",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 25),

              // 1. HTML Card dengan Logo Gambar
              _buildMenuMateri(
                context: context,
                imagePath: 'assets/images/html_logo.png',
                title: "HTML",
                subtitle: "Belajar dasar struktur website",
                badgeColor: const Color(0xFFFFF0E5),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HtmlMateriScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // 2. CSS Card dengan Logo Gambar
              _buildMenuMateri(
                context: context,
                imagePath: 'assets/images/css_logo.png',
                title: "CSS",
                subtitle: "Belajar styling dan layouting",
                badgeColor: const Color(0xFFEBF4FF),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CssMateriScreen()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // 3. JavaScript Card dengan Logo Gambar
              _buildMenuMateri(
                context: context,
                imagePath: 'assets/images/js_logo.png',
                title: "JavaScript",
                subtitle: "Belajar interaktivitas website",
                badgeColor: const Color(0xFFFFF7E5),
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

  Widget _buildMenuMateri({
    required BuildContext context,
    required String imagePath,
    required String title,
    required String subtitle,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05), // PERBAIKAN: Menggunakan .withValues
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          title.substring(0, 2).toUpperCase(),
                          style: TextStyle(color: Colors.deepPurple.shade700, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
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
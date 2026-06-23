import 'package:flutter/material.dart';
// Menghubungkan langsung ke file detail kuis tunggal
import 'quiz_detail_screen.dart'; 

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);

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
                "Kuis Kemampuan",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 25),

              // 1. Kuis HTML -> Masuk ke Menu Pilih Bab HTML
              _buildMenuQuiz(
                context: context,
                imagePath: 'assets/images/html_logo.png',
                title: "Kuis HTML Dasar",
                subtitle: "Uji pemahaman kerangka website",
                badgeColor: const Color(0xFFFFF0E5),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QuizDetailScreen(
                        kategori: "HTML", 
                        temaColor: Color(0xFFFF7A22),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // 2. Kuis CSS -> Masuk ke Menu Pilih Bab CSS
              _buildMenuQuiz(
                context: context,
                imagePath: 'assets/images/css_logo.png',
                title: "Kuis CSS Styling",
                subtitle: "Uji pemahaman menghias website",
                badgeColor: const Color(0xFFEBF4FF),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QuizDetailScreen(
                        kategori: "CSS", 
                        temaColor: Color(0xFF2196F3),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // 3. Kuis JavaScript -> Masuk ke Menu Pilih Bab JS
              _buildMenuQuiz(
                context: context,
                imagePath: 'assets/images/js_logo.png',
                title: "Kuis JavaScript",
                subtitle: "Uji pemahaman logika website",
                badgeColor: const Color(0xFFFFF7E5),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const QuizDetailScreen(
                        kategori: "JS", // Menggunakan key "JS" sesuai dengan repositori data kuis
                        temaColor: Color(0xFFFFB300),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Komponen Card Kuis dengan Ikon Panah Kanan Abu-abu (Chevron)
  Widget _buildMenuQuiz({
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
            color: Colors.black.withValues(alpha: 0.05),
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
                // Container Badge Logo
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
                          style: TextStyle(
                            color: Colors.deepPurple.shade700, 
                            fontWeight: FontWeight.bold, 
                            fontSize: 12,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                // Text Keterangan Kuis
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
                // Ikon Panah Sesuai Desain Halaman Materi
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
import 'package:flutter/material.dart';
import '../materi/materi_detail_screen.dart';

class MateriScreen extends StatelessWidget {
  const MateriScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🔥 OTOMATIS: Mengikuti background scaffold tema aktif
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Materi Pembelajaran",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color, // Teks dinamis
                ),
              ),
              const SizedBox(height: 25),

              _buildMenuMateri(
                context: context,
                imagePath: 'assets/images/html_logo.png',
                title: "HTML",
                subtitle: "Belajar dasar struktur website",
                badgeColor: const Color(0xFFFFF0E5),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MateriDetailScreen(
                        kategori: "HTML",
                        temaColor: Color(0xFFFF7A22),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildMenuMateri(
                context: context,
                imagePath: 'assets/images/css_logo.png',
                title: "CSS",
                subtitle: "Belajar mendesain tampilan website",
                badgeColor: const Color(0xFFEBF4FF),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MateriDetailScreen(
                        kategori: "CSS",
                        temaColor: Color(0xFF2196F3),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildMenuMateri(
                context: context,
                imagePath: 'assets/images/js_logo.png',
                title: "JavaScript",
                subtitle: "Belajar logika interaktif website",
                badgeColor: const Color(0xFFFFF7E5),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MateriDetailScreen(
                        kategori: "JS",
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

  Widget _buildMenuMateri({
    required BuildContext context,
    required String imagePath,
    required String title,
    required String subtitle,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, // Kartu gelap/terang otomatis
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.transparent : Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.1) : badgeColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Image.asset(imagePath, width: 35, fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).dividerColor,
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
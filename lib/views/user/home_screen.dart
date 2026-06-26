import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart'; // <-- 1. Tambah pemanggil tema
import '../materi/materi_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF8200E6);
    
    // <-- 2. Cek apakah sekarang sedang mode gelap
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      // <-- 3. Otomatis gelap kalau isDark aktif, kalau tidak tetap pakai warna aslimu
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Ungu dengan Tambahan Ornamen Estetik (100% Tidak Ada yang Diubah)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
              child: Container(
                width: double.infinity,
                color: primaryPurple,
                child: Stack(
                  children: [
                    const Positioned(
                      top: -20,
                      right: -50,
                      child: CircleAvatar(radius: 90, backgroundColor: Color(0x1AFFFFFF)),
                    ),
                    const Positioned(
                      bottom: 40,
                      left: -30,
                      child: CircleAvatar(radius: 60, backgroundColor: Color(0x1AFFFFFF)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 25),
                      child: Column(
                        children: [
                          const Text(
                            "Halo Mahasiswa",
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Belajar HTML, CSS, dan JavaScript\nlebih mudah dan moderen.",
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          Container(
                            constraints: const BoxConstraints(maxHeight: 180),
                            width: double.infinity,
                            child: Image.asset('assets/images/Gambar1.png', fit: BoxFit.contain),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Daftar Kelas "Dinamis & Real-Time"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lanjutkan Belajar",
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      // <-- 4. Teks judul ikut jadi putih pas mode gelap
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),

                  _buildMenuCard(
                    context: context,
                    title: "HTML Dasar",
                    categoryId: "HTML",
                    themeColor: const Color(0xFFFF7A22), 
                    imagePath: 'assets/images/html_logo.png',
                  ),
                  const SizedBox(height: 15),

                  _buildMenuCard(
                    context: context,
                    title: "CSS Styling",
                    categoryId: "CSS",
                    themeColor: const Color(0xFF2196F3), 
                    imagePath: 'assets/images/css_logo.png',
                  ),
                  const SizedBox(height: 15),

                  _buildMenuCard(
                    context: context,
                    title: "JavaScript",
                    categoryId: "JS",
                    themeColor: const Color(0xFFFFB300), 
                    imagePath: 'assets/images/js_logo.png',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // 🛠️ REFACTOR ENGINE: Mengubah UI Dummy menjadi Sinkronisasi Firestore Real-Time
  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required String categoryId,
    required Color themeColor,
    required String imagePath,
  }) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String? userId = authProvider.currentUser?.uid;
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode; // <-- Panggil tema di dalam card

    if (userId == null) {
      return const SizedBox(
        height: 80,
        child: Center(child: Text("Sesi berakhir, silakan login kembali.")),
      );
    }

    return StreamBuilder<DocumentSnapshot>(
      // Ambil data total bab materi dari koleksi courses admin
      stream: FirebaseFirestore.instance.collection('courses').doc(categoryId).snapshots(),
      builder: (context, courseSnapshot) {
        int totalBabCount = 0;
        if (courseSnapshot.hasData && courseSnapshot.data!.exists) {
          final data = courseSnapshot.data!.data() as Map<String, dynamic>?;
          if (data != null && data['daftar_bab'] != null) {
            totalBabCount = (data['daftar_bab'] as List).length;
          }
        }

        return StreamBuilder<DocumentSnapshot>(
          // Ambil data sub-koleksi progress milik user saat ini
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('progress')
              .doc(categoryId)
              .snapshots(),
          builder: (context, progressSnapshot) {
            int babSelesaiCount = 0;
            if (progressSnapshot.hasData && progressSnapshot.data!.exists) {
              final data = progressSnapshot.data!.data() as Map<String, dynamic>?;
              if (data != null && data['bab_selesai'] != null) {
                babSelesaiCount = (data['bab_selesai'] as List).length;
              }
            }

            // Hitung persentase progres matematika
            double progressValue = 0.0;
            if (totalBabCount > 0) {
              progressValue = babSelesaiCount / totalBabCount;
            }
            int percentage = (progressValue * 100).round();

            // Ubah label teks progress secara kondisional
            String progressText = "$percentage% selesai ($babSelesaiCount/$totalBabCount Materi)";
            if (totalBabCount == 0) {
              progressText = "Materi belum dimasukkan oleh admin";
            }

            // Aturan penamaan tulisan button sesuai progres user
            String buttonText = "Mulai Belajar";
            if (percentage > 0 && percentage < 100) {
              buttonText = "Lanjut Belajar";
            } else if (percentage == 100 && totalBabCount > 0) {
              buttonText = "Selesai Belajar 🎉";
            }

            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                // <-- 5. Kotak kartu otomatis berubah gelap
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.transparent : const Color(0x0A000000), 
                    blurRadius: 10, 
                    offset: const Offset(0, 5)
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 85,
                          height: 85,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                        ),
                        Image.asset(imagePath, height: 70, fit: BoxFit.contain),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title, 
                          style: TextStyle(
                            fontSize: 15, 
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87, // <-- 6. Judul kartu ikut memutih
                          )
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progressValue,
                          backgroundColor: isDark ? const Color(0xFF334155) : Colors.grey[100],
                          color: themeColor,
                          minHeight: 5,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          progressText, 
                          style: TextStyle(
                            fontSize: 12, 
                            color: isDark ? const Color(0xFF94A3B8) : Colors.grey[500], // <-- 7. Subtitle menyesuaikan
                          )
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0), 
                                width: 1.2
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              backgroundColor: percentage == 100 
                                  ? (isDark ? Colors.green.withValues(alpha: 0.2) : Colors.green.withValues(alpha: 0.1)) 
                                  : null,
                            ),
                            onPressed: () {
                              // Navigasi aktif langsung menembak ke materi bersangkutan
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MateriDetailScreen(
                                    kategori: categoryId,
                                    temaColor: themeColor,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              buttonText, 
                              style: TextStyle(
                                color: percentage == 100 
                                    ? (isDark ? Colors.green[400] : Colors.green[700]) 
                                    : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155)), // <-- 8. Warna teks tombol menyesuaikan
                                fontSize: 13, 
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
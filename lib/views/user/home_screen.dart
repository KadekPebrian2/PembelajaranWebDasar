import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const primaryPurple = Color(0xFF8200E6);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Ungu dengan Tambahan Ornamen Estetik
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
                    // Ornamen Geometris
                    const Positioned(
                      top: -20,
                      right: -50,
                      child: CircleAvatar(
                        radius: 90,
                        backgroundColor: Color(0x1AFFFFFF), // Putih transparan 10%
                      ),
                    ),
                    const Positioned(
                      bottom: 40,
                      left: -30,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Color(0x1AFFFFFF), 
                      ),
                    ),

                    // Konten Utama Header
                    Padding(
                      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 25),
                      child: Column(
                        children: [
                          const Text(
                            "Halo Mahasiswa",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Belajar HTML, CSS, dan JavaScript\nlebih mudah dan moderen.",
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          
                          // Gambar Utama yang menonjol
                          Container(
                            constraints: const BoxConstraints(maxHeight: 180),
                            width: double.infinity,
                            child: Image.asset(
                              'assets/images/Gambar1.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Daftar Kelas "Lanjutkan Belajar"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Lanjutkan Belajar",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 15),

                  _buildMenuCard(
                    title: "HTML Dasar",
                    progress: 0.5,
                    progressText: "50% selesai",
                    themeColor: const Color(0xFFF06529),
                    bgInitial: "5",
                  ),
                  const SizedBox(height: 15),

                  _buildMenuCard(
                    title: "CSS Styling",
                    progress: 0.5,
                    progressText: "50% selesai",
                    themeColor: const Color(0xFF2965F1),
                    bgInitial: "3",
                  ),
                  const SizedBox(height: 15),

                  _buildMenuCard(
                    title: "JavaScript",
                    progress: 0.6,
                    progressText: "60% selesai",
                    themeColor: const Color(0xFFF7DF1E),
                    bgInitial: "JS",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required double progress,
    required String progressText,
    required Color themeColor,
    required String bgInitial,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000), 
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 85,
            width: double.infinity,
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                bgInitial,
                style: const TextStyle(
                  color: Color(0x40FFFFFF), // Putih transparan agar inisial terlihat samar 
                  fontSize: 45, 
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[100],
                  color: themeColor,
                  minHeight: 5,
                  borderRadius: BorderRadius.circular(10), // Membulatkan ujung bar progress
                ),
                const SizedBox(height: 6),
                Text(progressText, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 38,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.black26),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {},
                    child: const Text("Lanjut Belajar", style: TextStyle(color: Colors.black87, fontSize: 13)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
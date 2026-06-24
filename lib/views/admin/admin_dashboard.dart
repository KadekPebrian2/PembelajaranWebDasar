import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

// Import file manajemen
import 'manage_materi_screen.dart';
import 'manage_quiz_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentTabIndex = 0;

  void _handleLogout() {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  // Fungsi Helper untuk Dialog Tambah Pembelajaran/Kategori Baru
  void _showTambahKategoriDialog(BuildContext context) {
    final TextEditingController _kategoriController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Pembelajaran Baru", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: TextField(
          controller: _kategoriController,
          decoration: const InputDecoration(
            hintText: "Masukkan nama materi (Contoh: PHP, Python)",
            hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6B11D6)),
            onPressed: () {
              final namaKategori = _kategoriController.text.trim();
              if (namaKategori.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Kategori '$namaKategori' berhasil dibuat!")),
                );
              }
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          _buildHomeTab(),           
          _buildSettingsTab(),      
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentTabIndex,
          selectedItemColor: const Color(0xFF6B11D6), 
          unselectedItemColor: const Color(0xFF94A3B8),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          onTap: (index) {
            setState(() {
              _currentTabIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(_currentTabIndex == 0 ? Icons.home_filled : Icons.home_outlined),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(_currentTabIndex == 1 ? Icons.settings_rounded : Icons.settings_outlined),
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  // ================= TAB 1: BERANDA / HOME TAB (GABUNGAN) =================
  Widget _buildHomeTab() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          "Dashboard Admin",
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF0F172A)),
            tooltip: 'Logout dari Sistem',
            onPressed: _handleLogout,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BANNER SELAMAT DATANG
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B11D6),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6B11D6).withValues(alpha: 0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    )
                  ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Selamat Datang\nAdmin!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Pantau perkembangan pembelajaran dan kelola ekosistem akademik anda dalam satu tampilan dashboard yang terintegrasi.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // STATISTIK UTAMA
              const Text(
                "Statistik Utama",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBF4FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.assignment_turned_in_rounded, color: Color(0xFF2563EB), size: 20),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              "Rata-rata Skor Quiz",
                              style: TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const Text(
                          "Stabil",
                          style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "84.2%",
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF0F172A)),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: 0.842,
                      backgroundColor: const Color(0xFFE2E8F0),
                      color: const Color(0xFF6B11D6),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // SECTION KELOLA KONTEN (PINDAHAN DARI TAB KONTEN)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Kelola Materi & Kuis",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  // Tombol Tambah Baru untuk Pembelajaran Baru berada di sini
                  SizedBox(
                    height: 34,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B11D6),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      onPressed: () {
                        _showTambahKategoriDialog(context);
                      },
                      icon: const Icon(Icons.add, color: Colors.white, size: 16),
                      label: const Text(
                        "Tambah Baru",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // DAFTAR KARTU PEMBELAJARAN
              _buildAdminMateriCard(
                imageAssetPath: "assets/images/html_logo.png",
                kategoriBadge: "HTML",
                badgeBg: const Color(0xFFFFEFE5),
                badgeText: const Color(0xFFFF7A22),
                borderColor: const Color(0xFFFF7A22),
                title: "Dasar-Dasar HTML",
                subtitle: "Kuasai komponen struktural web",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CategoryDetailScreen(kategoriId: 1, judulKategori: "HTML"),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildAdminMateriCard(
                imageAssetPath: "assets/images/css_logo.png",
                kategoriBadge: "CSS",
                badgeBg: const Color(0xFFEBF4FF),
                badgeText: const Color(0xFF2196F3),
                borderColor: const Color(0xFF2196F3),
                title: "Dasar-Dasar CSS",
                subtitle: "Kuasai gaya komponen visual web",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CategoryDetailScreen(kategoriId: 2, judulKategori: "CSS"),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              _buildAdminMateriCard(
                imageAssetPath: "assets/images/js_logo.png",
                kategoriBadge: "JS",
                badgeBg: const Color(0xFFFFF7E5),
                badgeText: const Color(0xFFFFB300),
                borderColor: const Color(0xFFFFB300),
                title: "Dasar-Dasar JavaScript",
                subtitle: "Kuasai logika manipulasi web",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CategoryDetailScreen(kategoriId: 3, judulKategori: "JavaScript"),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdminMateriCard({
    required String imageAssetPath,
    required String kategoriBadge,
    required Color badgeBg,
    required Color badgeText,
    required Color borderColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          kategoriBadge,
                          style: TextStyle(color: badgeText, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      Image.asset(
                        imageAssetPath,
                        width: 28,
                        height: 28,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.code_rounded, color: badgeText, size: 24);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 16),
                  Container(height: 1, color: const Color(0xFFF1F5F9)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(Icons.arrow_forward_ios_rounded, color: const Color(0xFF6B11D6), size: 14),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "Ketuk untuk membuka edit materi dan kuis",
                          style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
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

  // ================= TAB 2: SETTINGS TAB =================
  Widget _buildSettingsTab() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Pengaturan Sistem",
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded, color: Colors.redAccent),
            title: const Text("Logout Akun Admin", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
            subtitle: const Text("Keluar dengan aman dari sistem kendali akademik"),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
            onTap: _handleLogout,
          ),
        ],
      ),
    );
  }
}

class CategoryDetailScreen extends StatelessWidget {
  final int kategoriId;
  final String judulKategori;

  const CategoryDetailScreen({Key? key, required this.kategoriId, required this.judulKategori}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "Detail $judulKategori",
          style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF9033FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Edit Materi & Kuis",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Di dalam $judulKategori, Anda bisa mengelola materi dan kuis tanpa kembali ke tampilan utama.",
                      style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildActionCard(
                context,
                title: "Kelola Materi $judulKategori",
                subtitle: "Buka daftar materi yang bisa ditambah atau diedit",
                icon: Icons.book_rounded,
                color: const Color(0xFF6B11D6),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ManageMateriScreen(judulKategori: judulKategori)),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildActionCard(
                context,
                title: "Kelola Kuis $judulKategori",
                subtitle: "Buka paket kuis dan sunting soal langsung di dalam kategori",
                icon: Icons.quiz_rounded,
                color: const Color(0xFFFFB300),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ManageQuizScreen(judulKategori: judulKategori)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context,
      {required String title,
      required String subtitle,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }
}

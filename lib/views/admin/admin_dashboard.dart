import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          _buildHomeTab(),           
          _buildKelolaMateriTab(),  
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
                child: Icon(_currentTabIndex == 1 ? Icons.assignment_rounded : Icons.assignment_outlined),
              ),
              label: 'Konten',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(_currentTabIndex == 2 ? Icons.settings_rounded : Icons.settings_outlined),
              ),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  // ================= TAB 1: BERANDA / HOME TAB =================
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
                      "pantau perkembangan pembelajaran dan kelola ekosistem akademik anda dalam satu tampilan dashboard yang terintegrasi.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 180,
                      height: 42,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF6B11D6),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _currentTabIndex = 1; 
                          });
                        },
                        icon: const Icon(Icons.edit_note_rounded, size: 20),
                        label: const Text("Kelola Materi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Statistik Utama",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
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
            ],
          ),
        ),
      ),
    );
  }

  // ================= TAB 2: KELOLA MATERI TAB =================
  Widget _buildKelolaMateriTab() {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 18),
          onPressed: () {
            setState(() {
              _currentTabIndex = 0; 
            });
          },
        ),
        title: const Text(
          "Kelola Materi",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFFE2E8F0),
              radius: 18,
              child: Icon(Icons.person_rounded, color: Color(0xFF64748B), size: 20),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Cari Materi Pembelajaran....",
                    hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                    prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 22),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 42,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B11D6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.add, color: Colors.white, size: 18),
                  label: const Text(
                    "Tambah Baru",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // LIST KARTU MANAJEMEN MATERI MENGGUNAKAN LOGO ASSET .PNG
              _buildAdminMateriCard(
                imageAssetPath: "assets/images/html_logo.png", // <--- Ganti sesuai folder asetmu
                kategoriBadge: "HTML",
                badgeBg: const Color(0xFFFFEFE5),
                badgeText: const Color(0xFFFF7A22),
                borderColor: const Color(0xFFFF7A22),
                title: "Dasar-Dasar HTML",
                subtitle: "Kuasai komponen struktural web",
                onEditKuis: () {},
                onEditMateri: () {},
              ),
              const SizedBox(height: 18),

              _buildAdminMateriCard(
                imageAssetPath: "assets/images/css_logo.png",  // <--- Ganti sesuai folder asetmu
                kategoriBadge: "CSS",
                badgeBg: const Color(0xFFEBF4FF),
                badgeText: const Color(0xFF2196F3),
                borderColor: const Color(0xFF2196F3),
                title: "Dasar-Dasar CSS",
                subtitle: "Kuasai gaya komponen visual web",
                onEditKuis: () {},
                onEditMateri: () {},
              ),
              const SizedBox(height: 18),

              _buildAdminMateriCard(
                imageAssetPath: "assets/images/js_logo.png",   // <--- Ganti sesuai folder asetmu
                kategoriBadge: "JS",
                badgeBg: const Color(0xFFFFF7E5),
                badgeText: const Color(0xFFFFB300),
                borderColor: const Color(0xFFFFB300),
                title: "Dasar-Dasar JavaScript",
                subtitle: "Kuasai logika manipulasi web",
                onEditKuis: () {},
                onEditMateri: () {},
              ),
              const SizedBox(height: 20),
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
    required VoidCallback onEditKuis,
    required VoidCallback onEditMateri,
  }) {
    return Container(
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
                    // Menampilkan Gambar Logo PNG secara elegan di sudut kanan atas kartu
                    Image.asset(
                      imageAssetPath,
                      width: 28,
                      height: 28,
                      errorBuilder: (context, error, stackTrace) {
                        // Backup jika path salah agar aplikasi tidak crash
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildOutlinedActionButton(label: "Edit Kuis", onTap: onEditKuis),
                    const SizedBox(width: 10),
                    _buildOutlinedActionButton(label: "Edit Materi", onTap: onEditMateri),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutlinedActionButton({required String label, required VoidCallback onTap}) {
    return SizedBox(
      height: 34,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF9033FF), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 14),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: const TextStyle(color: Color(0xFF9033FF), fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }

  // ================= TAB 3: SETTINGS TAB =================
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
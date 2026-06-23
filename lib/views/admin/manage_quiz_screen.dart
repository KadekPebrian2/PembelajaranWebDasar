import 'package:flutter/material.dart';
import 'edit_quiz_screen.dart';

// =========================================================================
// 1. HALAMAN UTAMA MANAGE QUIZ (MENAMPILKAN DAFTAR KUIS 1, KUIS 2, DST)
// =========================================================================
class ManageQuizScreen extends StatelessWidget {
  final String judulKategori;

  const ManageQuizScreen({Key? key, required this.judulKategori}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data dummy daftar paket kuis bertingkat
    final List<Map<String, dynamic>> daftarPaketQuiz = [
      {"id": "1", "nama_kuis": "Kuis 1: Pengenalan Dasar", "jumlah_soal": "5 Soal"},
      {"id": "2", "nama_kuis": "Kuis 2: Struktur & Tag Elemen", "jumlah_soal": "10 Soal"},
      {"id": "3", "nama_kuis": "Kuis 3: Atribut & Boilerplate", "jumlah_soal": "8 Soal"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("Paket Kuis $judulKategori", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          // TOMBOL TAMBAH PAKET KUIS BARU (Misal: Membuat Kuis 4)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9033FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  // Aksi untuk menambah paket Kuis baru (bukan soalnya)
                  _showTambahPaketQuizDialog(context);
                },
                icon: const Icon(Icons.add_box_rounded, color: Colors.white, size: 22),
                label: const Text("Tambah Paket Kuis Baru", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          ),
          
          // DAFTAR PAKET KUIS (KUIS 1, 2, 3)
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: daftarPaketQuiz.length,
              itemBuilder: (context, index) {
                final paket = daftarPaketQuiz[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.quiz_rounded, color: Color(0xFF9033FF)),
                    ),
                    title: Text(
                      paket["nama_kuis"]!,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 14),
                    ),
                    subtitle: Text(
                      paket["jumlah_soal"]!,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                    onTap: () {
                      // KETIKA DIKLIK: Masuk ke dalam detail untuk melihat list soal-soalnya
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailQuizQuestionsScreen(
                            namaPaketKuis: paket["nama_kuis"]!,
                            judulKategori: judulKategori,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Dialog Helper untuk Tambah Kuis Baru (Kuis 4, Kuis 5, dst)
  void _showTambahPaketQuizDialog(BuildContext context) {
    final TextEditingController _kuisController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Paket Kuis Baru", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        content: TextField(
          controller: _kuisController,
          decoration: const InputDecoration(
            hintText: "Contoh: Kuis 4: Semantic HTML",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9033FF)),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}


// =========================================================================
// 2. HALAMAN DETAIL SOAL DI DALAM KUIS YANG DIPILIH
// =========================================================================
class DetailQuizQuestionsScreen extends StatelessWidget {
  final String namaPaketKuis;
  final String judulKategori;

  const DetailQuizQuestionsScreen({
    Key? key, 
    required this.namaPaketKuis, 
    required this.judulKategori
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy Data Soal di dalam Kuis Terpilih
    final List<Map<String, String>> daftarSoal = [
      {"id": "1", "pertanyaan": "Apa kepanjangan dari HTML?", "opsi": "Hyper Text Markup Language"},
      {"id": "2", "pertanyaan": "Tag manakah yang digunakan untuk membuat baris baru?", "opsi": "<br>"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(namaPaketKuis, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: Column(
        children: [
          // TOMBOL TAMBAH SOAL BARU DI DALAM KUIS INI
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B11D6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  // Mengarah ke halaman pembuatan pertanyaan kuis baru
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditQuizScreen(judulKategori: "Tambah Soal Baru")),
                  );
                },
                icon: const Icon(Icons.playlist_add_rounded, color: Colors.white, size: 22),
                label: const Text("Tambah Soal Baru", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          ),

          // LIST PERTANYAAN YANG BISA DIEDIT / DIHAPUS
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: daftarSoal.length,
              itemBuilder: (context, index) {
                final kuis = daftarSoal[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                  ),
                  child: ExpansionTile(
                    shape: const Border(),
                    title: Text(
                      "Soal ${kuis["id"]}: ${kuis["pertanyaan"]}",
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B)),
                    ),
                    subtitle: Text("Kunci Jawaban: ${kuis["opsi"]}", style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w500)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                // Mengarah ke form edit soal yang sudah ada
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => EditQuizScreen(judulKategori: judulKategori)),
                                );
                              },
                              icon: const Icon(Icons.edit_note_rounded, color: Color(0xFF6B11D6), size: 18),
                              label: const Text("Edit Soal", style: TextStyle(color: Color(0xFF6B11D6), fontWeight: FontWeight.bold)),
                            ),
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.delete_sweep_rounded, color: Colors.redAccent, size: 18),
                              label: const Text("Hapus", style: TextStyle(color: Colors.redAccent)),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart'; // Menyesuaikan path folder kamu
import 'edit_quiz_screen.dart'; 

// ==========================================
// 1. HALAMAN UTAMA: MANAGE QUIZ SCREEN
// ==========================================
class ManageQuizScreen extends StatelessWidget {
  final String judulKategori;

  const ManageQuizScreen({Key? key, required this.judulKategori}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          "Paket Kuis $judulKategori", 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: Consumer<CourseProvider>(
        builder: (context, courseProvider, child) {
          final daftarPaket = courseProvider.daftarPaketQuiz;

          return Column(
            children: [
              // TOMBOL TAMBAH PAKET KUIS BARU
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
                    onPressed: () async {
                      final hasilDataBaru = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditQuizScreen(judulKategori: judulKategori, isEdit: false),
                        ),
                      );

                      if (hasilDataBaru != null && hasilDataBaru is Map<String, dynamic>) {
                        courseProvider.tambahPaketKuis(
                          hasilDataBaru["judul"] ?? "Kuis Baru",
                          List<Map<String, dynamic>>.from(hasilDataBaru["soal"] ?? []),
                        );
                      }
                    },
                    icon: const Icon(Icons.add_box_rounded, color: Colors.white, size: 22),
                    label: const Text(
                      "Tambah Paket Kuis Baru", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ),
              
              // DAFTAR LIST PAKET KUIS
              Expanded(
                child: daftarPaket.isEmpty
                    ? const Center(child: Text("Belum ada paket kuis."))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: daftarPaket.length,
                        itemBuilder: (context, index) {
                          final paket = daftarPaket[index];
                          final List listSoal = paket["soal_list"] ?? [];

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
                                paket["nama_kuis"] ?? "", 
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 14),
                              ),
                              subtitle: Text("${listSoal.length} Soal", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => DetailQuizQuestionsScreen(
                                      indeksPaket: index,
                                      namaPaketKuis: paket["nama_kuis"] ?? "",
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
          );
        },
      ),
    );
  }
}

// ==========================================
// 2. HALAMAN DETAIL: DETAIL QUIZ QUESTIONS SCREEN
// ==========================================
class DetailQuizQuestionsScreen extends StatelessWidget {
  final int indeksPaket;
  final String namaPaketKuis;
  final String judulKategori;

  const DetailQuizQuestionsScreen({
    Key? key, 
    required this.indeksPaket,
    required this.namaPaketKuis, 
    required this.judulKategori,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final paketKuis = courseProvider.daftarPaketQuiz[indeksPaket];
    final List daftarSoal = paketKuis["soal_list"] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          namaPaketKuis, 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 16),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: Column(
        children: [
          // TOMBOL TAMBAH SOAL BARU
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
                onPressed: () async {
                  final hasilDataBaru = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditQuizScreen(
                        judulKategori: judulKategori, 
                        namaKuisAwal: namaPaketKuis, 
                        isEdit: false,
                      ),
                    ),
                  );

                  if (hasilDataBaru != null && hasilDataBaru is Map<String, dynamic>) {
                    final List soalBaruDariForm = hasilDataBaru["soal"] ?? [];
                    final List updateListSoal = List.from(daftarSoal, growable: true)..addAll(soalBaruDariForm);
                    courseProvider.updateSoalKuis(indeksPaket, updateListSoal);
                  }
                },
                icon: const Icon(Icons.playlist_add_rounded, color: Colors.white, size: 22),
                label: const Text(
                  "Tambah Soal Baru", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ),

          // DAFTAR PERTANYAAN DI DALAM PAKET KUIS
          Expanded(
            child: daftarSoal.isEmpty
                ? const Center(child: Text("Belum ada pertanyaan di kuis ini.", style: TextStyle(color: Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: daftarSoal.length,
                    itemBuilder: (context, index) {
                      final kuis = daftarSoal[index];
                      String teksPertanyaan = kuis["soal"] ?? "(Pertanyaan kosong)";
                      String opsiA = kuis["a"] ?? "";

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
                            "Soal ${index + 1}: $teksPertanyaan", 
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF1E293B)),
                          ),
                          subtitle: Text(
                            "Opsi A: $opsiA", 
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton.icon(
                                    onPressed: () async {
                                      final hasilEdit = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EditQuizScreen(
                                            judulKategori: judulKategori,
                                            namaKuisAwal: namaPaketKuis,
                                            isEdit: true,
                                            soalKuisAwal: daftarSoal, 
                                          ),
                                        ),
                                      );

                                      if (hasilEdit != null && hasilEdit is Map<String, dynamic>) {
                                        courseProvider.updateSoalKuis(indeksPaket, hasilEdit["soal"]);
                                      }
                                    },
                                    icon: const Icon(Icons.edit_note_rounded, color: Color(0xFF6B11D6), size: 18),
                                    label: const Text("Edit Soal", style: TextStyle(color: Color(0xFF6B11D6), fontWeight: FontWeight.bold)),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      final List updateListSoal = List.from(daftarSoal, growable: true)..removeAt(index);
                                      courseProvider.updateSoalKuis(indeksPaket, updateListSoal);
                                    },
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
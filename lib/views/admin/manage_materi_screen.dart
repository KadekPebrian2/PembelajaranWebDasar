import 'package:flutter/material.dart';
import 'edit_materi_screen.dart';

class ManageMateriScreen extends StatelessWidget {
  final String judulKategori;

  const ManageMateriScreen({Key? key, required this.judulKategori}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Contoh data statis berdasarkan screenshot materi yang kamu kirimkan
    final List<Map<String, String>> daftarSubMateri = [
      {"id": "1", "title": "1. Apa Sebenarnya HTML Itu?"},
      {"id": "2", "title": "2. Mengenal Anatomi Elemen & Tag"},
      {"id": "3", "title": "3. Susunan Boilerplate Standar HTML5"},
      {"id": "4", "title": "4. Bedah Kode Struktur Dokumen"},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text("Daftar Materi $judulKategori", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          // TOMBOL TAMBAH MATERI BARU (DI DALAM KATEGORI)
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
                  // Mengarah ke halaman EditMateriScreen untuk menambah materi baru
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditMateriScreen(judulKategori: "Tambah Baru")),
                  );
                },
                icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.white, size: 20),
                label: const Text("Tambah Materi Baru", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              ),
            ),
          ),
          
          // DAFTAR SUB-MATERI YANG BISA DIKLIK / DIEDIT
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: daftarSubMateri.length,
              itemBuilder: (context, index) {
                final materi = daftarSubMateri[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: Text(
                      materi["title"]!,
                      style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontSize: 14),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_rounded, color: Color(0xFF6B11D6), size: 20),
                          onPressed: () {
                            // Mengarah ke form edit materi lama
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => EditMateriScreen(judulKategori: judulKategori)),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                          onPressed: () {
                            // Handler hapus data materi
                          },
                        ),
                      ],
                    ),
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
import 'package:flutter/material.dart';
import 'materi_detail_screen.dart';

class HtmlMateriScreen extends StatelessWidget {
  const HtmlMateriScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const htmlColor = Color(0xFFFF7A22);

    final List<Map<String, dynamic>> htmlChapters = [
      {
        "id": "1",
        "title": "Anatomi & Struktur Utama HTML",
        "subtitle": "Mengupas tuntas susunan dokumen web",
        "isi": [
          {"type": "header", "value": "1. Apa Sebenarnya HTML Itu?"},
          {"type": "text", "value": "HTML (HyperText Markup Language) adalah bahasa standar global yang digunakan untuk membuat dan menyusun kerangka dasar sebuah halaman web. HTML bukan bahasa pemrograman yang memiliki logika rumit, melainkan bahasa penanda (markup) yang memberi tahu web browser bagaimana sebuah teks, gambar, atau link harus ditampilkan."},
          {"type": "text", "value": "Tanpa HTML, halaman web tidak akan pernah ada. Jika dianalogikan seperti tubuh manusia, HTML adalah susunan tulang belulang yang menentukan bentuk dasar tubuh sebelum ditutupi oleh pakaian atau kulit."},
          {"type": "header", "value": "2. Mengenal Anatomi Elemen & Tag"},
          {"type": "text", "value": "Setiap komponen di dalam HTML disebut sebagai elemen, dan elemen tersebut dibuat menggunakan 'tag'. Tag ditulis menggunakan tanda kurung siku pembuka (<...>) dan ditutup dengan tanda kurung siku penutup yang memiliki garis miring (</...>). Teks atau konten utama akan diletakkan di antara kedua tag tersebut."},
          {"type": "header", "value": "3. Susunan Boilerplate Standar HTML5"},
          {"type": "text", "value": "Saat Anda ingin membuat file HTML baru, web browser mewajibkan adanya struktur template standar universal (Boilerplate). Berikut adalah struktur wajib yang harus ditulis di awal pembuatan halaman web:"},
          {
            "type": "code",
            "value": "<!DOCTYPE html>\n<html lang=\"id\">\n  <head>\n    <meta charset=\"UTF-8\">\n    <title>Halaman Web Pertama Saya</title>\n  </head>\n  <body>\n    <h1>Selamat Datang di WebLearn!</h1>\n    <p>Ini adalah paragraf artikel pertama saya.</p>\n  </body>\n</html>"
          },
          {"type": "header", "value": "4. Bedah Kode Struktur Dokumen"},
          {"type": "text", "value": "• <!DOCTYPE html> : Deklarasi ini berada di baris paling atas untuk memberi tahu browser bahwa dokumen ini menggunakan standar HTML5 versi terbaru.\n\n• <html> : Root element atau tag induk utama. Semua kode HTML wajib berada di dalam ruang lingkup tag ini.\n\n• <head> : Bagian kepala halaman yang menyimpan informasi teknis (metadata) di balik layar. Apa yang ditulis di dalam head tidak akan muncul langsung di halaman utama website.\n\n• <title> : Bagian dari head yang berfungsi menentukan teks judul yang muncul pada tab atas web browser Anda.\n\n• <body> : Tubuh utama halaman web. Seluruh elemen visual seperti teks, gambar, video, tombol, dan form wajib diletakkan di dalam tag body ini agar bisa dilihat oleh pengunjung web."},
          {"type": "tip", "value": "Tag pembuka dan penutup adalah satu kesatuan mutlak. Lupa menuliskan tag penutup (seperti </p> atau </body>) sering kali menjadi penyebab utama mengapa tampilan website menjadi berantakan!"},
        ]
      }
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 25, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: htmlColor,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("HTML Dasar", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("1 Bab Terfokus", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: htmlChapters.length,
              itemBuilder: (context, index) {
                final ch = htmlChapters[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: htmlColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        ch['id'], 
                        style: const TextStyle(color: htmlColor, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    title: Text(ch['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
                    subtitle: Text(ch['subtitle'], style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                    trailing: const Icon(Icons.chevron_right, size: 20, color: Color(0xFFCBD5E1)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MateriDetailScreen(
                            kategori: "HTML", 
                            title: ch['title'],
                            konten: List<Map<String, dynamic>>.from(ch['isi']),
                            temaColor: htmlColor,
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
}
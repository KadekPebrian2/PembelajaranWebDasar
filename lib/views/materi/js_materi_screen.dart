import 'package:flutter/material.dart';
import 'materi_detail_screen.dart';

class JsMateriScreen extends StatelessWidget {
  const JsMateriScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> jsTopics = const [
    {
      "id": "1",
      "title": "Pengenalan JavaScript",
      "subtitle": "Interaktivitas Logika Web",
      "content": '''
JavaScript adalah bahasa pemrograman paling populer di dunia. Jika HTML menyusun kerangka dan CSS menghias tampilan, maka JavaScript bertugas memberikan "otak" atau logika interaktif agar halaman web bisa hidup.

Kenapa Belajar JavaScript?
• Dapat mengubah konten HTML secara dinamis.
• Dapat mengubah nilai atribut HTML (misal mengganti gambar saat diklik).
• Dapat memvalidasi data formulir sebelum dikirim ke server.

Cara Memasukkan JavaScript ke HTML:
Sama seperti CSS, kode JS diletakkan di dalam tag khusus, yaitu tag <script>.
Contoh:
<script>
  console.log("Halo dari JavaScript!");
</script>

File Eksternal:
Bisa dipisah menjadi file ber-ekstensi .js lalu dipanggil dengan atribut 'src'.
Contoh: <script src="script.js"></script>''',
    },
    {
      "id": "2",
      "title": "Variabel & Tipe Data",
      "subtitle": "Penyimpanan Memori Data",
      "content": '''
VARIABEL JAVASCRIPT:
Variabel adalah wadah atau kontainer untuk menyimpan nilai data sementara di memori komputer.
JavaScript modern menggunakan 3 kata kunci untuk membuat variabel:

1. var : Cara lama (sebaiknya dihindari karena scope-nya terlalu luas).
2. let : Mengumumkan variabel yang nilainya BISA diubah nanti.
   Contoh: let umur = 20; umur = 21; (Boleh)
3. const : Mengumumkan konstanta yang nilainya TETAP dan tidak bisa diubah setelah diisi pertama kali.
   Contoh: const pi = 3.14;

TIPE DATA UTAMA DI JS:
• String : Data teks, ditulis di dalam tanda kutip. Contoh: let nama = "Kadek";
• Number : Data angka (bulat maupun desimal). Contoh: let harga = 5000;
• Boolean : Nilai logika, hanya berisi true (benar) atau false (salah).
• Array : Wadah untuk menyimpan banyak data sekaligus dalam satu variabel. Contoh: let buah = ["Apel", "Jeruk"];''',
    },
    {
      "id": "3",
      "title": "Fungsi (Functions)",
      "subtitle": "Blok Kode Reusable",
      "content": '''
Fungsi (Function) adalah sekumpulan blok kode logika yang dirancang untuk melakukan tugas tertentu secara berulang-ulang tanpa perlu mengetik ulang kodenya.

Sintaks Pembuatan Fungsi:
Gunakan kata kunci 'function', diikuti nama fungsi, dan tanda kurung ().

Contoh Pembuatan:
function sapaPengguna(nama) {
  return "Selamat datang, " + nama;
}

Cara Memanggil Fungsi:
Untuk mengeksekusi fungsi di atas, panggil namanya beserta isian datanya (argumen).
Contoh: let hasil = sapaPengguna("Budi");
Maka variabel 'hasil' sekarang berisi teks "Selamat datang, Budi".

Fungsi Event Handler:
Di dalam website, fungsi sering kali dipicu oleh aksi user, misalnya saat tombol di-klik (onclick).
Contoh: <button onclick="jalankanFungsi()">Klik Saya</button>''',
    },
  ];

  @override
  Widget build(BuildContext context) {
    const primaryAmber = Color(0xFFFFB300); // Tema Warna JavaScript

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // HEADER KUNING AMBER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: primaryAmber,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
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
                    Text("JavaScript", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    Text("Belajar interaktivitas website", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),

          // LIST MATERI
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              itemCount: jsTopics.length,
              itemBuilder: (context, index) {
                final topic = jsTopics[index];
                return _buildTopicCard(context, topic, primaryAmber, index + 1);
              },
            ),
          ),

          // BUTTON KUIS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryAmber, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {},
                child: const Text("Mulai Kuis JS", style: TextStyle(color: primaryAmber, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(BuildContext context, Map<String, String> topic, Color primaryColor, int nomorBab) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MateriDetailScreen(
                  title: topic['title']!,
                  content: topic['content']!,
                  colorTheme: primaryColor,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(color: primaryColor.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: Text(nomorBab.toString(), style: TextStyle(color: primaryColor, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(topic['title']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 3),
                      Text(topic['subtitle']!, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.black45),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
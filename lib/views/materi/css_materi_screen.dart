import 'package:flutter/material.dart';
import 'materi_detail_screen.dart';

class CssMateriScreen extends StatelessWidget {
  const CssMateriScreen({Key? key}) : super(key: key);

  final List<Map<String, String>> cssTopics = const [
    {
      "id": "1",
      "title": "Sintaks & Selektor",
      "subtitle": "Cara Kerja & Target Elemen",
      "content": '''
CSS singkatan dari Cascading Style Sheets. CSS digunakan untuk mengatur gaya visual (desain) dari halaman web yang dibuat menggunakan HTML.

SINTAKS CSS:
Aturan CSS terdiri dari sebuah selector dan sebuah declaration block.
Format: selector { property: value; }

Contoh:
h1 {
  color: blue;
  font-size: 12px;
}
• h1 adalah Selector (menunjuk elemen HTML yang mau diubah).
• color adalah Property (fitur yang mau diubah).
• blue adalah Value (nilai baru untuk properti tersebut).

3 MACAM SELEKTOR UTAMA:
1. Element Selector: Memilih elemen berdasarkan nama tag.
   Contoh: p { text-align: center; }
2. Id Selector (#): Memilih elemen spesifik berdasarkan atribut id.
   Contoh: #judulUtama { color: red; }
3. Class Selector (.): Memilih kelompok elemen yang memiliki atribut class yang sama.
   Contoh: .teks-hijau { color: green; }''',
    },
    {
      "id": "2",
      "title": "Cara Menambahkan CSS",
      "subtitle": "External, Internal, & Inline",
      "content": '''
Ada 3 cara untuk menuliskan atau memasukkan kode CSS ke dalam dokumen HTML Anda menurut standar W3Schools:

1. External CSS:
   Kode CSS ditulis di file terpisah dengan ekstensi .css, lalu dipanggil di dalam tag <head> HTML menggunakan tag <link>. Cara ini adalah yang paling direkomendasikan karena codingan HTML dan CSS terpisah rapi.
   Contoh:
   <link rel="stylesheet" href="style.css">

2. Internal CSS:
   Kode CSS ditulis langsung di dalam satu file HTML, diletakkan di dalam tag <style> yang berada di area <head>. Cocok jika satu halaman tersebut memiliki gaya yang unik sendiri.
   Contoh:
   <head>
     <style>
       body { background-color: linen; }
     </style>
   </head>

3. Inline CSS:
   Kode CSS ditulis langsung menempel pada tag HTML yang bersangkutan menggunakan atribut 'style'. Cara ini kurang disarankan untuk skala besar karena membuat file HTML menjadi sangat panjang dan kotor.
   Contoh:
   <h1 style="color:blue; text-align:center;">Judul Biru</h1>''',
    },
    {
      "id": "3",
      "title": "Warna & Background",
      "subtitle": "Pewarnaan Elemen Web",
      "content": '''
CSS WARNA (Colors):
Warna dalam CSS bisa ditentukan dengan beberapa cara:
1. Menggunakan Nama Warna Resmi: red, tomato, dodgerblue, gray, dll.
2. Menggunakan Nilai HEX: #ff5733
3. Menggunakan Nilai RGB: rgb(255, 99, 71)

Properti Warna Teks:
Gunakan properti 'color' untuk mengubah warna teks.
Contoh: p { color: violet; }

CSS BACKGROUND:
Properti background digunakan untuk memberikan efek visual pada latar belakang suatu elemen web.
• background-color: Mengubah warna latar.
  Contoh: body { background-color: lightblue; }
• background-image: Memasang gambar sebagai latar belakang.
  Contoh: body { background-image: url("awan.png"); }
• background-repeat: Mengatur apakah gambar latar boleh mengulang (repeat) jika ukuran layar terlalu besar atau cukup sekali saja (no-repeat).''',
    },
    {
      "id": "4",
      "title": "CSS Box Model",
      "subtitle": "Margin, Border, & Padding",
      "content": '''
Box Model adalah konsep paling penting dalam tata letak (layouting) CSS. Semua elemen HTML dapat dianggap sebagai sebuah kotak kotak ("box").

Dalam CSS, Box Model membungkus elemen HTML dan terdiri dari beberapa lapisan (dari dalam ke luar):

1. Content (Konten): Tempat di mana teks atau gambar sebenarnya dari elemen tersebut berada.
2. Padding (Bantalan Dalam): Membersihkan area di SEKITAR konten. Padding bersifat transparan dan berada di dalam border.
   Contoh: p { padding: 20px; }
3. Border (Bingkai): Garis yang membungkus padding dan konten.
   Contoh: p { border: 2px solid black; }
4. Margin (Jarak Luar): Membersihkan area di LUAR border. Margin digunakan untuk mengatur jarak antar elemen HTML agar tidak saling menempel.
   Contoh: p { margin: 15px; }''',
    },
  ];

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2196F3); // Tema Warna CSS

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // HEADER BIRU
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: primaryBlue,
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
                    Text("CSS Dasar", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    Text("Belajar styling dan layouting", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),

          // LIST MATERI
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              itemCount: cssTopics.length,
              itemBuilder: (context, index) {
                final topic = cssTopics[index];
                return _buildTopicCard(context, topic, primaryBlue, index + 1);
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
                  side: const BorderSide(color: primaryBlue, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {},
                child: const Text("Mulai Kuis CSS", style: TextStyle(color: primaryBlue, fontSize: 16, fontWeight: FontWeight.bold)),
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
import 'package:flutter/material.dart';
import 'materi_detail_screen.dart';

class HtmlMateriScreen extends StatelessWidget {
  const HtmlMateriScreen({Key? key}) : super(key: key);

  // DATA MATERI LENGKAP ADAPTASI DARI W3SCHOOLS HTML TUTORIAL
  final List<Map<String, String>> htmlTopics = const [
    {
      "id": "1",
      "title": "Pengenalan & Struktur",
      "subtitle": "Definisi & Boilerplate Utama",
      "content": '''
HTML singkatan dari HyperText Markup Language. Ini bukan bahasa pemrograman, melainkan bahasa markup standar untuk menstrukturkan atau menyusun sebuah halaman web.

Elemen HTML digambarkan oleh "tag", yang ditulis menggunakan tanda kurung siku seperti <html>, <body>, <p>. Browser tidak menampilkan tag ini, melainkan menggunakannya untuk memahami bagaimana isi halaman harus ditampilkan.

STRUKTUR DASAR (BOILERPLATE):
Setiap membuat file HTML, strukturnya wajib diawali seperti ini:

<!DOCTYPE html>
<html>
  <head>
    <title>Judul Tab Browser</title>
  </head>
  <body>
    <h1>Ini Heading Utama</h1>
    <p>Ini sebuah paragraf dokumen.</p>
  </body>
</html>

PENJELASAN ELEMEN:
1. <!DOCTYPE html> : Pengumuman ke browser bahwa dokumen ini bermutu HTML5 (versi terbaru).
2. <html> : Akar (root) yang membungkus seluruh konten web.
3. <head> : Tempat menyimpan data meta (informasi latar belakang dokumen yang tidak langsung terlihat di halaman web, seperti judul tab).
4. <body> : Tubuh web. Semua hal yang ditulis di dalam body (teks, gambar, tombol, video) akan terlihat oleh pengguna.''',
    },
    {
      "id": "2",
      "title": "Elemen & Atribut",
      "subtitle": "Tag Pembuka, Isi, & Properti",
      "content": '''
ELEMEN HTML:
Elemen adalah segalanya mulai dari tag pembuka, isi konten, hingga tag penutup.
Format umum: <tagname> Konten Anda... </tagname>

Contoh Elemen:
• <p>Ini Paragraf</p> (Elemen paragraf utuh).
• <h1>Ini Judul</h1> (Elemen heading utuh).

Ada juga elemen yang TIDAK memiliki tag penutup, disebut Empty Elements (elemen kosong). Contohnya tag <br> untuk pindah baris baru, dan tag <hr> untuk membuat garis horizontal.

ATRIBUT HTML:
Atribut digunakan untuk memberikan informasi tambahan pada suatu elemen.
Aturan Atribut:
1. Selalu ditambahkan di dalam TAG PEMBUKA.
2. Biasanya berpasangan antara nama dan nilai, formatnya: nama="nilai".

CONTOH ATRIBUT POPULER (W3SCHOOLS):
• Atribut href: Digunakan pada tag <a> untuk menentukan alamat link tujuan.
  Contoh: <a href="https://google.com">Buka Google</a>

• Atribut src: Digunakan pada tag <img> untuk menentukan jalur/sumber file gambar.
  Contoh: <img src="gambar.jpg">

• Atribut style: Digunakan untuk menambah estetika langsung (inline CSS) seperti warna, ukuran teks, dan font.
  Contoh: <p style="color: red;">Teks ini berwarna merah</p>''',
    },
    {
      "id": "3",
      "title": "Heading & Paragraf",
      "subtitle": "Struktur Teks Dokumen",
      "content": '''
HEADING HTML (<h1> sampai <h6>):
Heading didefinisikan dengan tag <h1> hingga <h6>. <h1> adalah tingkat tertinggi (paling besar/penting) dan <h6> adalah yang terendah (paling kecil).

Contoh Penggunaan:
<h1>Heading Tingkat 1 (Sangat Besar)</h1>
<h2>Heading Tingkat 2</h2>
<h3>Heading Tingkat 3</h3>

PENTING UNTUK SEO:
Mesin pencari seperti Google menggunakan heading untuk memahami struktur dan topik halaman web Anda. Gunakan <h1> hanya untuk judul utama halaman, diikuti <h2> untuk sub-bab, dst. Jangan pakai heading hanya untuk mempertebal teks biasa!

PARAGRAF HTML (<p>):
Paragraf ditulis menggunakan tag <p>. Secara otomatis, browser akan memberikan sedikit ruang kosong (margin) sebelum dan sesudah tag <p> dibuat.

Sifat Unik Paragraf di Browser:
Browser akan menghapus spasi berlebih atau baris baru yang Anda ketik secara manual di text editor.
Contoh:
<p>
  Teks ini      ditulis berantakan
  banyak spasi.
</p>
Hasil di browser akan tetap sejajar rapi dalam satu baris biasa.

Solusi jika ingin baris baru:
Gunakan tag <br> untuk memaksa teks turun ke bawah, atau bungkus teks dengan tag <pre> (Preformatted text) agar bentuk tulisan persis seperti yang diketik di codingan.''',
    },
    {
      "id": "4",
      "title": "Pemformatan Teks",
      "subtitle": "Gaya Tulisan & Semantik",
      "content": '''
HTML menyediakan tag khusus untuk mengubah tampilan teks agar memiliki arti tertentu (Formatting). Berikut daftar pemformatan teks yang paling sering digunakan menurut dokumen W3Schools:

1. Tebal & Penting:
   • <b>Teks Bold</b> : Membuat teks menjadi tebal (hanya tampilan visual fisik saja).
   • <strong>Teks Strong</strong> : Membuat teks tebal DAN menandakan bahwa teks tersebut sangat penting (secara arti/semantik).

2. Miring & Penekanan:
   • <i>Teks Italic</i> : Membuat teks menjadi miring secara tampilan fisik.
   • <em>Teks Emphasized</em> : Membuat teks miring dan memberikan penekanan lisan saat dibaca oleh screen reader.

3. Penandaan & Ukuran:
   • <small>Teks Kecil</small> : Mengubah teks menjadi berukuran lebih kecil dari standar.
   • <mark>Teks Stabilo</mark> : Memberikan efek background kuning (sorotan) seperti stabilo pada teks.

4. Penghapusan & Sisipan:
   • <del>Teks Dicoret</del> : Memberikan garis coret di tengah huruf (menandakan teks telah dihapus/lama).
   • <ins>Teks Garis Bawah</ins> : Memberikan garis bawah pada teks (menandakan teks baru disisipkan).

5. Posisi Karakter:
   • Teks <sub>Subscript</sub> : Menurunkan posisi teks ke bawah (Contoh penulisan kimia: H₂O).
   • Teks <sup>Superscript</sup> : Menaikkan posisi teks ke atas (Contoh penulisan matematika / pangkat: 10²).''',
    },
    {
      "id": "5",
      "title": "Hyperlink & Gambar",
      "subtitle": "Navigasi Antar Web & Visual",
      "content": '''
HYPERLINK (<a>):
Link dalam HTML menggunakan elemen Anchor <a>. Link ini berfungsi menghubungkan halaman web Anda dengan halaman lainnya.

Format utama:
<a href="URL_TUJUAN" target="Sifat_Buka">Teks Tautan</a>

Penjelasan Atribut 'target':
• target="_self" (Bawaan) : Membuka link di tab browser yang sama.
• target="_blank" : Membuka link di TAB BARU, sehingga halaman web lama Anda tidak tertutup.

Contoh Nyata:
<a href="https://www.w3schools.com" target="_blank">Kunjungi W3Schools</a>


GAMBAR (<img>):
Gambar dimasukkan menggunakan tag <img>. Tag ini tidak memiliki tag penutup (Empty element).

Dua Atribut Wajib Gambar:
1. src (source) : Menunjuk lokasi file gambar disimpan (bisa berupa link internet atau file lokal).
2. alt (alternative text) : Teks pengganti yang akan muncul jika gambar gagal dimuat akibat internet lambat, sekaligus membantu penyandang disabilitas membaca isi gambar.

Atribut Tambahan:
• width (Lebar gambar) & height (Tinggi gambar) diisi menggunakan angka piksel (px).

Contoh Nyata:
<img src="https://www.w3schools.com/images/w3schools_green.jpg" alt="Logo W3Schools resmi" width="300" height="150">''',
    },
    {
      "id": "6",
      "title": "Daftar (List) & Tabel",
      "subtitle": "Menyusun Data Terstruktur",
      "content": '''
LIST / DAFTAR HTML:
Ada dua jenis daftar utama yang digunakan untuk mengelompokkan data secara berurutan maupun acak:

1. Unordered List (<ul>):
   Daftar acak yang itemnya ditandai dengan simbol poin (bullet). Setiap item didalamnya dibungkus tag <li> (List Item).
   Contoh Kode:
   <ul>
     <li>Susu Sapi</li>
     <li>Roti Gandum</li>
   </ul>

2. Ordered List (<ol>):
   Daftar berurutan yang itemnya ditandai otomatis dengan nomor (1, 2, 3), huruf (A, B, C), atau romawi.
   Contoh Kode:
   <ol>
     <li>Buka Aplikasi</li>
     <li>Lakukan Login</li>
   </ol>

TABEL HTML (<table>):
Tabel digunakan untuk merapikan data ke dalam susunan kotak baris dan kolom. 

Tag Utama Penyusun Tabel:
• <table> : Pembungkus utama area tabel.
• <tr> (Table Row) : Membuat baris baru di tabel.
• <th> (Table Header) : Membuat sel judul kolom (teks otomatis tebal dan di tengah).
• <td> (Table Data) : Membuat sel isi data biasa.

Contoh Struktur Tabel Lengkap:
<table>
  <tr>
    <th>Nama</th>
    <th>Nilai</th>
  </tr>
  <tr>
    <td>Kadek</td>
    <td>95</td>
  </tr>
  <tr>
    <td>Budi</td>
    <td>88</td>
  </tr>
</table>''',
    },
  ];

  @override
  Widget build(BuildContext context) {
    const primaryOrange = Color(0xFFFF7A22); // Warna oranye sesuai desain gambar_5b73db

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // HEADER ORANYE (Sesuai Mockup Asli Anda)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 30, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: primaryOrange,
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
                    Text(
                      "HTML Dasar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Belajar dasar membuat website",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // DAFTAR BAB LIST MATERI
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              itemCount: htmlTopics.length,
              itemBuilder: (context, index) {
                final topic = htmlTopics[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        // Lompat ke detail pembacaan materi
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MateriDetailScreen(
                              title: topic['title']!,
                              content: topic['content']!,
                              colorTheme: primaryOrange,
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          children: [
                            // Kotak Label Angka Bab
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: primaryOrange.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                topic['id']!,
                                style: const TextStyle(
                                  color: primaryOrange,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            
                            // Konten Teks Deskripsi Bab
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    topic['title']!,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    topic['subtitle']!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Panah Chevron Kanan
                            const Icon(Icons.chevron_right, color: Colors.black45),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // OUTLINED BUTTON MULAI KUIS (Di bagian bawah halaman list)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryOrange, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  // Jalur fitur kuis HTML Anda nanti
                },
                child: const Text(
                  "Mulai Kuis",
                  style: TextStyle(
                    color: primaryOrange,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
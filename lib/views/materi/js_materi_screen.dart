// import 'package:flutter/material.dart';
// import 'materi_detail_screen.dart';

// class JsMateriScreen extends StatelessWidget {
//   const JsMateriScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     const jsColor = Color(0xFFFFB300);

//     final List<Map<String, dynamic>> jsChapters = [
//       {
//         "id": "1",
//         "title": "Logika & Variabel Modern JavaScript",
//         "subtitle": "Mengenal sistem memori let dan const",
//         "isi": [
//           {"type": "header", "value": "1. JavaScript: Otak dari Website"},
//           {"type": "text", "value": "JavaScript (JS) adalah bahasa pemrograman sesungguhnya yang bertugas memberikan logika, kecerdasan, dan elemen interaktif pada halaman web Anda. Jika HTML membuat kerangka dan CSS menghias tampilan, maka JavaScript bertugas memberikan fungsi nyata—seperti memproses data formulir, kalkulasi matematika, memunculkan pop-up dinamis, hingga mengambil data dari server."},
//           {"type": "header", "value": "2. Apa itu Variabel?"},
//           {"type": "text", "value": "Dalam pemrograman, variabel adalah sebuah wadah penampung fiktif di dalam memori komputer yang digunakan untuk menyimpan suatu nilai informasi data (seperti angka, nama user, atau status login) agar bisa kita panggil dan kita manipulasi di baris kode selanjutnya."},
//           {"type": "header", "value": "3. Contoh Penggunaan Variabel Modern"},
//           {"type": "text", "value": "Pada standar JavaScript modern, kita menggunakan kata kunci 'let' dan 'const' untuk mendeklarasikan atau melahirkan sebuah variabel baru:"},
//           {
//             "type": "code",
//             "value": "let namaSiswa = \"Rian\";\nconst nilaiKunci = 99.5;\n\nnamaSiswa = \"Budi\"; // Nilai berhasil diubah!"
//           },
//           {"type": "header", "value": "4. Perbedaan Mutlak let vs const"},
//           {"type": "text", "value": "• let : Digunakan untuk mendeklarasikan variabel yang nilainya bersifat dinamis (fleksibel). Nilai di dalam variabel ini dapat diubah atau ditimpa kembali di baris kode bawahnya, seperti variabel 'namaSiswa' di atas.\n\n• const (Constant) : Digunakan untuk menyimpan nilai yang bersifat konstan (tetap). Sekali nilai dimasukkan ke dalam variabel const, nilai tersebut terkunci permanen dan tidak akan pernah bisa diubah lagi oleh program. Jika Anda mencoba mengubah nilai 'nilaiKunci', sistem akan langsung mengeluarkan pesan eror."},
//           {"type": "tip", "value": "Gunakan selalu kata kunci 'const' secara default untuk semua variabel di kodingan Anda. Hanya beralihlah menggunakan 'let' jika Anda tahu pasti bahwa nilai data tersebut akan berubah di kemudian waktu. Ini adalah praktik koding terbaik industri saat ini!"},
//         ]
//       }
//     ];

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FA),
//       body: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.only(top: 50, bottom: 25, left: 20, right: 20),
//             decoration: const BoxDecoration(
//               color: jsColor,
//               borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
//             ),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.white),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 const SizedBox(width: 10),
//                 const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("JavaScript Dasar", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
//                     Text("1 Bab Terfokus", style: TextStyle(color: Colors.white70, fontSize: 13)),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(20),
//               itemCount: jsChapters.length,
//               itemBuilder: (context, index) {
//                 final ch = jsChapters[index];
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
//                   ),
//                   child: ListTile(
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                     leading: Container(
//                       width: 42,
//                       height: 42,
//                       decoration: BoxDecoration(
//                         color: jsColor.withValues(alpha: 0.1),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         ch['id'], 
//                         style: const TextStyle(color: jsColor, fontWeight: FontWeight.bold, fontSize: 16),
//                       ),
//                     ),
//                     title: Text(ch['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
//                     subtitle: Text(ch['subtitle'], style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
//                     trailing: const Icon(Icons.chevron_right, size: 20, color: Color(0xFFCBD5E1)),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => MateriDetailScreen(
//                             kategori: "JS", 
//                             title: ch['title'],
//                             konten: List<Map<String, dynamic>>.from(ch['isi']),
//                             temaColor: jsColor,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
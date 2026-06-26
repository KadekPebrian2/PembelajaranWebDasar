// import 'package:flutter/material.dart';
// import 'materi_detail_screen.dart';

// class CssMateriScreen extends StatelessWidget {
//   const CssMateriScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     const cssColor = Color(0xFF2196F3);

//     final List<Map<String, dynamic>> cssChapters = [
//       {
//         "id": "1",
//         "title": "Sintaks Dasar & Aturan Selektor CSS",
//         "subtitle": "Menguasai cara menghias halaman web",
//         "isi": [
//           {"type": "header", "value": "1. Mengapa Kita Membutuhkan CSS?"},
//           {"type": "text", "value": "CSS (Cascading Style Sheets) adalah bahasa desain yang digunakan untuk mengatur tampilan visual dari dokumen HTML. Jika HTML berfungsi untuk membuat struktur teks dan tombol, maka CSS berfungsi untuk mewarnai, mengatur font, mengatur ukuran elemen, hingga menentukan tata letak (layout) agar website terlihat indah dan profesional di layar HP maupun laptop."},
//           {"type": "header", "value": "2. Tiga Komponen Utama Aturan CSS"},
//           {"type": "text", "value": "Kode CSS ditulis dengan aturan yang baku dan memiliki struktur yang terbagi menjadi tiga bagian penting, yaitu: Selector (Target elemen), Property (Jenis gaya), dan Value (Nilai gaya)."},
//           {"type": "header", "value": "3. Contoh Penulisan Kode CSS"},
//           {"type": "text", "value": "Berikut adalah bentuk penulisan standar blok deklarasi CSS untuk menghias elemen HTML:"},
//           {
//             "type": "code",
//             "value": "p {\n  color: #2196F3;\n  font-size: 16px;\n  text-align: center;\n}"
//           },
//           {"type": "header", "value": "4. Bedah Aturan dan Cara Kerja"},
//           {"type": "text", "value": "• p (Selector) : Bagian ini bertugas menunjuk target elemen HTML mana yang ingin diubah gayanya. Pada contoh di atas, kita menargetkan semua tag paragraf (<p>) yang ada di dokumen web.\n\n• color (Property) : Atribut visual apa yang ingin kita ubah. Di baris pertama, kita ingin mengubah warna teks dari paragraf tersebut.\n\n• #2196F3 (Value) : Nilai baru yang diberikan kepada property. Di sini kita menggunakan kode warna Hexadecimal untuk menghasilkan warna biru cerah.\n\n• Kurung Kurawal { ... } : Blok pembungkus yang menandakan awal dan akhir dari seluruh instruksi dekorasi gaya untuk selector terkait."},
//           {"type": "tip", "value": "Setiap kali Anda selesai menulis satu baris property dan value, Anda wajib menutupnya dengan tanda titik koma ( ; ). Jika lupa, web browser akan bingung membaca baris berikutnya dan seluruh desain web Anda bisa gagal dimuat!"},
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
//               color: cssColor,
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
//                     Text("CSS Dasar", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
//                     Text("1 Bab Terfokus", style: TextStyle(color: Colors.white70, fontSize: 13)),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(20),
//               itemCount: cssChapters.length,
//               itemBuilder: (context, index) {
//                 final ch = cssChapters[index];
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
//                         color: cssColor.withValues(alpha: 0.1),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       alignment: Alignment.center,
//                       child: Text(
//                         ch['id'], 
//                         style: const TextStyle(color: cssColor, fontWeight: FontWeight.bold, fontSize: 16),
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
//                             kategori: "CSS", 
//                             title: ch['title'],
//                             konten: List<Map<String, dynamic>>.from(ch['isi']),
//                             temaColor: cssColor,
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
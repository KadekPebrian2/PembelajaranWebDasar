import 'package:flutter/material.dart';

class EditQuizScreen extends StatefulWidget {
  final String judulKategori; // "HTML", "CSS", "JS"
  final String? namaKuisAwal;
  const EditQuizScreen({Key? key, required this.judulKategori, this.namaKuisAwal}) : super(key: key);

  @override
  State<EditQuizScreen> createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  late TextEditingController _judulQuizController;

  @override
  void initState() {
    super.initState();
    _judulQuizController = TextEditingController(
      text: widget.namaKuisAwal ?? "Kuis Baru ${widget.judulKategori}"
    );
  }

  // Membuat visual placeholder bank soal berdasarkan jenis kategori yang dipilih
  List<Map<String, dynamic>> _getPlaceholderSoal() {
    if (widget.judulKategori.toUpperCase() == 'HTML') {
      return [
        {"soal": "Tag apa yang digunakan untuk membuat judul utama dokumen?", "a": "<h1>", "b": "<head>", "c": "<title>", "d": "<p>"},
        {"soal": "Karakter apa yang menandakan tag penutup dokumen HTML?", "a": "<", "b": "/", "c": "*", "d": "^"}
      ];
    } else if (widget.judulKategori.toUpperCase() == 'CSS') {
      return [
        {"soal": "Properti CSS apa yang digunakan untuk mengubah warna teks latar belakang?", "a": "color", "b": "background-color", "c": "text-style", "d": "font-color"},
        {"soal": "Selector manakah yang digunakan untuk menargetkan ID spesifik?", "a": ".class", "b": "#id", "c": "*", "d": "element"}
      ];
    } else {
      return [
        {"soal": "Keyword apa yang digunakan untuk mendeklarasikan nilai variabel konstan mutlak?", "a": "let", "b": "var", "c": "const", "d": "set"}
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final listSoal = _getPlaceholderSoal();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7A22), // Header Orange sesuai desain utama Anda
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Edit Detail Quiz ${widget.judulKategori}",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const Text("Judul Kuis", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))),
          const SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: TextField(
              controller: _judulQuizController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Pertanyaan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
          const SizedBox(height: 12),

          // Render butir pertanyaan dinamis sesuai isi data penampung di atas
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listSoal.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildQuestionCard(
                  number: "${index + 1}",
                  pertanyaan: listSoal[index]["soal"]!,
                  pilA: listSoal[index]["a"]!,
                  pilB: listSoal[index]["b"]!,
                  pilC: listSoal[index]["c"]!,
                  pilD: listSoal[index]["d"]!,
                ),
              );
            },
          ),

          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFCBD5E1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF64748B), size: 18),
            label: const Text("Tambah Pernyataan Baru", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 30),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF6B11D6)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size(0, 44),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal", style: TextStyle(color: Color(0xFF6B11D6), fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B11D6),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    minimumSize: const Size(0, 44),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Perubahan bank kuis berhasil disimpan!")),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQuestionCard({
    required String number, 
    required String pertanyaan,
    required String pilA,
    required String pilB,
    required String pilC,
    required String pilD
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFFFFEFE5),
                radius: 14,
                child: Text(number, style: const TextStyle(color: Color(0xFFFF7A22), fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(width: 10),
              const Text("Teks Pertanyaan", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569), fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
            child: TextField(
              controller: TextEditingController(text: pertanyaan),
              maxLines: 2,
              decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(10)),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),
          _buildOptionField("A", pilA),
          _buildOptionField("B", pilB),
          _buildOptionField("C", pilC),
          _buildOptionField("D", pilD),
        ],
      ),
    );
  }

  Widget _buildOptionField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFF1F5F9),
            radius: 12,
            child: Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: TextField(
                controller: TextEditingController(text: value),
                decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10)),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
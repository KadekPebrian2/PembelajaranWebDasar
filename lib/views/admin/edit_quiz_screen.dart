import 'package:flutter/material.dart';

class EditQuizScreen extends StatefulWidget {
  final String judulKategori; 
  final String? namaKuisAwal;
  final bool isEdit;
  final List<dynamic>? soalKuisAwal; 

  const EditQuizScreen({
    Key? key, 
    required this.judulKategori, 
    this.namaKuisAwal, 
    this.isEdit = false,
    this.soalKuisAwal,
  }) : super(key: key);

  @override
  State<EditQuizScreen> createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  late TextEditingController _judulQuizController;
  List<Map<String, dynamic>> _listSoal = [];

  bool get isEdit => widget.isEdit;

  @override
  void initState() {
    super.initState();
    _judulQuizController = TextEditingController(
      text: widget.namaKuisAwal ?? (isEdit ? '' : 'Kuis Baru ${widget.judulKategori}')
    );
    
    if (isEdit && widget.soalKuisAwal != null) {
      _listSoal = widget.soalKuisAwal!.map((item) {
        final Map<dynamic, dynamic> mapLokal = item as Map;
        return {
          "soal": mapLokal["soal"]?.toString() ?? "",
          "a": mapLokal["a"]?.toString() ?? "",
          "b": mapLokal["b"]?.toString() ?? "",
          "c": mapLokal["c"]?.toString() ?? "",
          "d": mapLokal["d"]?.toString() ?? "",
          "jawaban_benar": mapLokal["jawaban_benar"]?.toString() ?? "a",
        };
      }).toList();
    } else {
      _tambahPertanyaanBarisKosong();
    }
  }

  void _tambahPertanyaanBarisKosong() {
    setState(() {
      _listSoal.add({
        "soal": "",
        "a": "",
        "b": "",
        "c": "",
        "d": "",
        "jawaban_benar": "a"
      });
    });
  }

  @override
  void dispose() {
    _judulQuizController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF7A22),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEdit ? "Edit Kuis ${widget.judulKategori}" : "Tambah Kuis Baru",
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

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _listSoal.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildQuestionCard(
                  index: index,
                  number: "${index + 1}",
                  pertanyaan: _listSoal[index]["soal"] ?? "",
                  pilA: _listSoal[index]["a"] ?? "",
                  pilB: _listSoal[index]["b"] ?? "",
                  pilC: _listSoal[index]["c"] ?? "",
                  pilD: _listSoal[index]["d"] ?? "",
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
            onPressed: _tambahPertanyaanBarisKosong,
            icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF64748B), size: 18),
            label: const Text("Tambah Pertanyaan Baru", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
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
                    if (_judulQuizController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Judul kuis tidak boleh kosong!")),
                      );
                      return;
                    }

                    Map<String, dynamic> hasilDataKuis = {
                      "judul": _judulQuizController.text,
                      "soal": List<Map<String, dynamic>>.from(_listSoal),
                    };

                    Navigator.pop(context, hasilDataKuis);
                  },
                  child: Text(isEdit ? "Simpan Perubahan" : "Simpan", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQuestionCard({
    required int index,
    required String number, 
    required String pertanyaan,
    required String pilA,
    required String pilB,
    required String pilC,
    required String pilD,
  }) {
    return Container(
      key: UniqueKey(), 
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              if (_listSoal.length > 1)
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                  onPressed: () {
                    setState(() {
                      _listSoal.removeAt(index);
                    });
                  },
                )
            ],
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
            child: TextFormField(
              initialValue: pertanyaan,
              maxLines: 2,
              onChanged: (val) => _listSoal[index]["soal"] = val,
              decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.all(10), hintText: "Ketik pertanyaan di sini..."),
              style: const TextStyle(fontSize: 13),
            ),
          ),
          const SizedBox(height: 12),
          _buildOptionField(index, "A", "a", pilA),
          _buildOptionField(index, "B", "b", pilB),
          _buildOptionField(index, "C", "c", pilC),
          _buildOptionField(index, "D", "d", pilD),
        ],
      ),
    );
  }

  Widget _buildOptionField(int index, String label, String keyMap, String value) {
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
              child: TextFormField(
                initialValue: value,
                onChanged: (val) => _listSoal[index][keyMap] = val,
                decoration: InputDecoration(border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), hintText: "Pilihan $label"),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
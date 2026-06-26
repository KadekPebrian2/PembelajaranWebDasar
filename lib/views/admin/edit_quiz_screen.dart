import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Model Lokal untuk manajemen form dinamis
class QuestionModel {
  TextEditingController soalCtrl;
  TextEditingController opsiACtrl;
  TextEditingController opsiBCtrl;
  TextEditingController opsiCCtrl;
  TextEditingController opsiDCtrl;
  TextEditingController jawabanCtrl;

  QuestionModel({String? soal, List<dynamic>? opsi, String? jawaban})
      : soalCtrl = TextEditingController(text: soal ?? ''),
        opsiACtrl = TextEditingController(text: opsi != null && opsi.isNotEmpty ? opsi[0].toString() : ''),
        opsiBCtrl = TextEditingController(text: opsi != null && opsi.length > 1 ? opsi[1].toString() : ''),
        opsiCCtrl = TextEditingController(text: opsi != null && opsi.length > 2 ? opsi[2].toString() : ''),
        opsiDCtrl = TextEditingController(text: opsi != null && opsi.length > 3 ? opsi[3].toString() : ''),
        jawabanCtrl = TextEditingController(text: jawaban ?? '');

  void dispose() {
    soalCtrl.dispose();
    opsiACtrl.dispose();
    opsiBCtrl.dispose();
    opsiCCtrl.dispose();
    opsiDCtrl.dispose();
    jawabanCtrl.dispose();
  }
}

class EditQuizScreen extends StatefulWidget {
  final String category;
  final Map<String, dynamic>? paketData; // Data 1 Paket
  final int? index;

  const EditQuizScreen({
    Key? key,
    required this.category,
    this.paketData,
    this.index,
  }) : super(key: key);

  @override
  State<EditQuizScreen> createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulPaketController;
  List<QuestionModel> _questions = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _judulPaketController = TextEditingController(text: widget.paketData?['judul_paket'] ?? '');
    
    // Load soal yang ada, atau buat 1 soal kosong jika buat baru
    if (widget.paketData != null && widget.paketData!['pertanyaan'] != null) {
      List<dynamic> pertanyaanLama = widget.paketData!['pertanyaan'];
      for (var p in pertanyaanLama) {
        _questions.add(QuestionModel(soal: p['soal'], opsi: p['opsi'], jawaban: p['jawaban_benar']));
      }
    } else {
      _questions.add(QuestionModel());
    }
  }

  @override
  void dispose() {
    _judulPaketController.dispose();
    for (var q in _questions) {
      q.dispose();
    }
    super.dispose();
  }

  void _addNewQuestion() {
    setState(() {
      _questions.add(QuestionModel());
    });
  }

  void _removeQuestion(int index) {
    if (_questions.length > 1) {
      setState(() {
        _questions[index].dispose();
        _questions.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kuis minimal harus ada 1 soal!')));
    }
  }

  void _deleteEntirePaket() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Paket Kuis'),
        content: const Text('Yakin ingin menghapus seluruh paket kuis ini beserta soal-soalnya?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await FirebaseFirestore.instance.collection('kuis').doc(widget.category).update({
          'daftar_paket': FieldValue.arrayRemove([widget.paketData])
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paket berhasil dihapus!')));
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: $e')));
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _saveQuizPacket() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    // Build data paket
    List<Map<String, dynamic>> listSoalToSave = [];
    for (var q in _questions) {
      listSoalToSave.add({
        'soal': q.soalCtrl.text.trim(),
        'opsi': [
          q.opsiACtrl.text.trim(),
          q.opsiBCtrl.text.trim(),
          q.opsiCCtrl.text.trim(),
          q.opsiDCtrl.text.trim(),
        ],
        'jawaban_benar': q.jawabanCtrl.text.trim(),
      });
    }

    final newPaketData = {
      'judul_paket': _judulPaketController.text.trim(),
      'pertanyaan': listSoalToSave,
    };

    try {
      final docRef = FirebaseFirestore.instance.collection('kuis').doc(widget.category);
      final docSnap = await docRef.get();

      if (widget.paketData == null) {
        // TAMBAH PAKET BARU
        await docRef.set({
          'daftar_paket': FieldValue.arrayUnion([newPaketData])
        }, SetOptions(merge: true));
      } else {
        // EDIT PAKET LAMA
        if (docSnap.exists) {
          List<dynamic> listPaketTemp = List.from(docSnap.data()?['daftar_paket'] ?? []);
          listPaketTemp[widget.index!] = newPaketData;
          await docRef.update({'daftar_paket': listPaketTemp});
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paket Kuis sukses disimpan!')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.paketData != null;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Kuis ${widget.category}' : 'Tambah Kuis Baru', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18)),
        backgroundColor: const Color(0xFFFF7A22), 
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: false,
        actions: [
          if (isEdit)
            IconButton(
              icon: const Icon(Icons.delete_forever_rounded),
              tooltip: 'Hapus Paket Kuis',
              onPressed: _deleteEntirePaket,
            )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF7A22)))
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Judul Kuis", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155), fontSize: 14)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _judulPaketController,
                              decoration: InputDecoration(
                                hintText: 'Contoh: Kuis 1: Pengenalan Dasar',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (v) => v!.isEmpty ? 'Judul kuis tidak boleh kosong' : null,
                            ),
                            const SizedBox(height: 24),
                            const Text("Pertanyaan", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155), fontSize: 16)),
                            const SizedBox(height: 12),
                            
                            // List of Dynamic Question Forms
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _questions.length,
                              itemBuilder: (context, index) {
                                return _buildQuestionCard(index, _questions[index]);
                              },
                            ),

                            // Tambah Pertanyaan Button
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: OutlinedButton.icon(
                                onPressed: _addNewQuestion,
                                icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF64748B)),
                                label: const Text("Tambah Pertanyaan Baru", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  side: const BorderSide(color: Color(0xFFE2E8F0)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Bottom Actions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFE2E8F0)))),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Color(0xFF6B11D6)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal', style: TextStyle(color: Color(0xFF6B11D6), fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6B11D6),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _saveQuizPacket,
                            child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildQuestionCard(int index, QuestionModel qModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Color(0xFFFFF0E6), shape: BoxShape.circle),
                    child: Text('${index + 1}', style: const TextStyle(color: Color(0xFFFF7A22), fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  const Text("Teks Pertanyaan", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF64748B), fontSize: 13)),
                ],
              ),
              if (_questions.length > 1) // Cuma bisa hapus kalau soal lebih dari 1
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.redAccent, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _removeQuestion(index),
                )
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: qModel.soalCtrl,
            decoration: InputDecoration(
              hintText: 'Ketik pertanyaan di sini...',
              fillColor: const Color(0xFFF8FAFC),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
            maxLines: 2,
            validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
          ),
          const SizedBox(height: 16),
          _buildOptionField('A', qModel.opsiACtrl),
          const SizedBox(height: 8),
          _buildOptionField('B', qModel.opsiBCtrl),
          const SizedBox(height: 8),
          _buildOptionField('C', qModel.opsiCCtrl),
          const SizedBox(height: 8),
          _buildOptionField('D', qModel.opsiDCtrl),
          const SizedBox(height: 16),
          TextFormField(
            controller: qModel.jawabanCtrl,
            decoration: InputDecoration(
              labelText: 'Kunci Jawaban Benar',
              hintText: 'Penting: Ketik jawaban persis seperti opsi di atas',
              labelStyle: const TextStyle(color: Colors.green),
              prefixIcon: const Icon(Icons.check_circle_outline_rounded, color: Colors.green),
              fillColor: const Color(0xFFF0FDF4),
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFBBF7D0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFBBF7D0))),
            ),
            validator: (v) => v!.isEmpty ? 'Kunci jawaban tidak boleh kosong' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildOptionField(String label, TextEditingController ctrl) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
          child: Text(label, style: const TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: ctrl,
            decoration: InputDecoration(
              hintText: 'Pilihan $label',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            ),
            validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditMateriScreen extends StatefulWidget {
  final String category;
  final Map<String, dynamic>? materiData;
  final int? index;

  const EditMateriScreen({
    Key? key,
    required this.category,
    this.materiData,
    this.index,
  }) : super(key: key);

  @override
  State<EditMateriScreen> createState() => _EditMateriScreenState();
}

class _EditMateriScreenState extends State<EditMateriScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulController;
  late TextEditingController _isiController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController(text: widget.materiData?['judul_bab'] ?? '');
    _isiController = TextEditingController(text: widget.materiData?['isi_materi'] ?? '');
  }

  @override
  void dispose() {
    _judulController.dispose();
    _isiController.dispose();
    super.dispose();
  }

  void _saveMateri() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final mapMateri = {
      'judul_bab': _judulController.text.trim(),
      'isi_materi': _isiController.text.trim(),
    };

    try {
      final docRef = FirebaseFirestore.instance.collection('courses').doc(widget.category);

      if (widget.materiData == null) {
        await docRef.set({
          'kategori': widget.category,
          'daftar_bab': FieldValue.arrayUnion([mapMateri])
        }, SetOptions(merge: true));
      } else {
        final docSnap = await docRef.get();
        if (docSnap.exists) {
          List<dynamic> listBabTemp = List.from(docSnap.data()?['daftar_bab'] ?? []);
          listBabTemp[widget.index!] = mapMateri;
          await docRef.update({'daftar_bab': listBabTemp});
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Materi sukses disimpan!')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal menyimpan materi: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.materiData != null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Materi' : 'Tambah Materi Baru', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B), fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6B11D6)))
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
                            // Header Banner (Oranye)
                            if (!isEdit)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF7A22),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Modul: Pemrograman Dasar", style: TextStyle(color: Colors.white70, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    Text(widget.category, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    const Text("Modul ini membahas tentang struktur dasar dokumen web menggunakan bahasa markup terbaru.", style: TextStyle(color: Colors.white, fontSize: 13)),
                                  ],
                                ),
                              ),
                            if (!isEdit) const SizedBox(height: 20),
                            
                            const Text("Judul Materi", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _judulController,
                              decoration: InputDecoration(
                                hintText: 'Contoh: 1. Pengenalan HTML',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              validator: (v) => v!.isEmpty ? 'Judul tidak boleh kosong' : null,
                            ),
                            const SizedBox(height: 20),

                            // Info Box Panduan Format (Biru)
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F5FF),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: const Color(0xFFD6E4FF)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFF2563EB)),
                                      SizedBox(width: 8),
                                      Text("Panduan Kode Format Teks:", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2563EB), fontSize: 13)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const Text("• Gunakan ### [Judul] untuk Sub-Judul (Warna Oranye)\n• Bungkus kode dengan [CODE] ... [/CODE] untuk Blok Boilerplate\n• Bungkus dengan [NOTE] ... [/NOTE] untuk Kotak Peringatan Bohlam", 
                                    style: TextStyle(color: Color(0xFF3B82F6), fontSize: 12, height: 1.5)
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Toolbar Editor Palsu & Text Area
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: const BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                                      color: Color(0xFFF8FAFC),
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                                    ),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.format_bold_rounded, color: Color(0xFF64748B), size: 20),
                                        SizedBox(width: 16),
                                        Icon(Icons.format_italic_rounded, color: Color(0xFF64748B), size: 20),
                                        SizedBox(width: 16),
                                        Icon(Icons.format_underlined_rounded, color: Color(0xFF64748B), size: 20),
                                        SizedBox(width: 16),
                                        Icon(Icons.title_rounded, color: Color(0xFFFF7A22), size: 20),
                                        SizedBox(width: 16),
                                        Icon(Icons.code_rounded, color: Color(0xFF64748B), size: 20),
                                        SizedBox(width: 16),
                                        Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFFFD54F), size: 20),
                                      ],
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _isiController,
                                    decoration: const InputDecoration(
                                      hintText: 'Ketik isi materi di sini...',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(16),
                                    ),
                                    maxLines: 12,
                                    validator: (v) => v!.isEmpty ? 'Konten materi tidak boleh kosong' : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text("Lampiran/Media", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFE2E8F0), style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  const Icon(Icons.cloud_upload_outlined, size: 32, color: Color(0xFF64748B)),
                                  const SizedBox(height: 12),
                                  OutlinedButton.icon(
                                    onPressed: () {},
                                    icon: const Icon(Icons.attach_file_rounded, size: 16),
                                    label: const Text("Unggah File"),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xFF334155),
                                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Bottom Actions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
                    ),
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
                            onPressed: _saveMateri,
                            child: Text(isEdit ? 'Simpan Perubahan' : 'Simpan', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
}
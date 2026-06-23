import 'package:flutter/material.dart';

class EditMateriScreen extends StatefulWidget {
  final String judulKategori; // Contoh: "HTML"
  const EditMateriScreen({Key? key, required this.judulKategori}) : super(key: key);

  @override
  State<EditMateriScreen> createState() => _EditMateriScreenState();
}

class _EditMateriScreenState extends State<EditMateriScreen> {
  final TextEditingController _judulController = TextEditingController(text: "Anatomi & Struktur Utama HTML");
  
  // Mengisi teks awal sesuai dengan isi materi pada screenshot target
  final TextEditingController _isiController = TextEditingController(
    text: "### 3. Susunan Boilerplate Standar HTML5\n\n"
        "Saat Anda ingin membuat file HTML baru, web browser mewajibkan adanya struktur template standar universal (Boilerplate). Berikut adalah struktur wajib yang harus ditulis di awal pembuatan halaman web:\n\n"
        "[CODE]\n"
        "<!DOCTYPE html>\n"
        "<html lang=\"id\">\n"
        "<head>\n"
        "    <meta charset=\"UTF-8\">\n"
        "    <title>Halaman Web Pertama Saya</title>\n"
        "</head>\n"
        "<body>\n"
        "    <h1>Selamat Datang di WebLearn!</h1>\n"
        "    <p>Ini adalah paragraf artikel pertama saya.</p>\n"
        "</body>\n"
        "</html>\n"
        "[/CODE]\n\n"
        "### 4. Bedah Kode Struktur Dokumen\n\n"
        "• <!DOCTYPE html> : Deklarasi ini berada di baris paling atas untuk memberi tahu browser bahwa dokumen ini menggunakan standar HTML5 versi terbaru.\n\n"
        "• <html> : Root element atau tag induk utama. Semua kode HTML wajib berada di dalam ruang lingkup tag ini.\n\n"
        "[NOTE]\n"
        "Tag pembuka dan penutup adalah satu kesatuan mutlak. Lupa menuliskan tag penutup (seperti </p> atau </body>) sering kali menjadi penyebab utama mengapa tampilan website menjadi berantakan!\n"
        "[/NOTE]"
  );

  // Status simulasi untuk file yang diunggah oleh admin
  String? _namaFileDiupload;
  String? _ukuranFileDiupload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Detail Materi",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_as_rounded, color: Color(0xFF6B11D6)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Perubahan materi berhasil disimpan ke Database!")),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Oranye Header Modul
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
                  Text(
                    "Modul: Pemrograman Dasar",
                    style: TextStyle(color: Colors.white.withAlpha(230), fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.judulKategori,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Modul ini membahas tentang struktur dasar dokumen web menggunakan bahasa markup ${widget.judulKategori} terbaru.",
                    style: TextStyle(color: Colors.white.withAlpha(216), fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Input Judul Materi
            const Text("Judul Materi", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155), fontSize: 13)),
            const SizedBox(height: 6),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                controller: _judulController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
            ),
            const SizedBox(height: 20),

            // KOTAK INFORMASI / PANDUAN STRUKTUR TEKS UNTUK ADMIN
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12), // <-- Sudah Diperbaiki ke EdgeInsets.only
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline_rounded, color: Color(0xFF1D4ED8), size: 16),
                      SizedBox(width: 6),
                      Text("Panduan Kode Format Teks:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF1D4ED8))),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text("• Gunakan ### [Judul] untuk Sub-Judul (Warna Oranye)", style: TextStyle(fontSize: 11, color: Color(0xFF1E40AF))),
                  Text("• Bungkus kode dengan [CODE] ... [/CODE] untuk Blok Boilerplate", style: TextStyle(fontSize: 11, color: Color(0xFF1E40AF))),
                  Text("• Bungkus dengan [NOTE] ... [/NOTE] untuk Kotak Peringatan Bohlam", style: TextStyle(fontSize: 11, color: Color(0xFF1E40AF))),
                ],
              ),
            ),

            // Toolbar Editor (Simulasi Aksi Sisipan Tag)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  _buildToolbarIcon(Icons.format_bold_rounded),
                  _buildToolbarIcon(Icons.format_italic_rounded),
                  _buildToolbarIcon(Icons.format_underlined_rounded),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.title_rounded, color: Color(0xFFFF7A22), size: 20),
                    onPressed: () => _insertTextTags("### ", ""),
                    tooltip: "Sub Judul",
                  ),
                  IconButton(
                    icon: const Icon(Icons.code_rounded, color: Color(0xFF64748B), size: 20),
                    onPressed: () => _insertTextTags("[CODE]\n", "\n[/CODE]"),
                    tooltip: "Blok Kode",
                  ),
                  IconButton(
                    icon: const Icon(Icons.lightbulb_outline_rounded, color: Colors.amber, size: 20),
                    onPressed: () => _insertTextTags("[NOTE]\n", "\n[/NOTE]"),
                    tooltip: "Kotak Peringatan",
                  ),
                ],
              ),
            ),
            
            // Text Area Isi Materi
            Container(
              constraints: const BoxConstraints(minHeight: 280), 
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
                border: Border.all(color: const Color(0xFFF1F5F9)),
              ),
              child: TextField(
                controller: _isiController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                  hintText: "Ketik isi materi di sini...",
                ),
                style: const TextStyle(fontSize: 13, height: 1.5, color: Color(0xFF334155)),
              ),
            ),
            const SizedBox(height: 20),

            // Bagian Lampiran/Media
            const Text("Lampiran/Media", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155), fontSize: 13)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  if (_namaFileDiupload == null) ...[
                    const Icon(Icons.cloud_upload_outlined, color: Color(0xFF64748B), size: 32),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        setState(() {
                          _namaFileDiupload = "Asset_Boilerplate_HTML5.zip";
                          _ukuranFileDiupload = "1.8 MB";
                        });
                      },
                      icon: const Icon(Icons.attachment_rounded, size: 16, color: Color(0xFF334155)),
                      label: const Text("Unggah File", style: TextStyle(color: Color(0xFF334155), fontSize: 12)),
                    )
                  ] else ...[
                    Row(
                      children: [
                        const Icon(Icons.insert_drive_file_rounded, color: Color(0xFFFF7A22), size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_namaFileDiupload!, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                              Text(_ukuranFileDiupload!, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel_rounded, color: Colors.redAccent),
                          onPressed: () {
                            setState(() {
                              _namaFileDiupload = null;
                              _ukuranFileDiupload = null;
                            });
                          },
                        )
                      ],
                    )
                  ],
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Tombol Aksi di Bawah
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
                        const SnackBar(content: Text("Perubahan berhasil diterapkan!")),
                      );
                    },
                    child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarIcon(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Icon(icon, color: const Color(0xFF64748B), size: 18),
    );
  }

  // Fungsi pembantu untuk menyisipkan tag format ke dalam posisi cursor pengetikan teks
  void _insertTextTags(String prefix, String suffix) {
    final text = _isiController.text;
    final selection = _isiController.selection;
    
    final newText = text.replaceRange(selection.start, selection.end, '$prefix$suffix');
    _isiController.text = newText;
    
    // Kembalikan fokus kursor ke posisi tengah tag setelah disisipkan
    _isiController.selection = TextSelection.collapsed(offset: selection.start + prefix.length);
  }
}
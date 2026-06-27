import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';

class MateriDetailScreen extends StatefulWidget {
  final String kategori; // HTML, CSS, atau JS
  final Color temaColor;

  const MateriDetailScreen({
    Key? key,
    required this.kategori,
    required this.temaColor,
  }) : super(key: key);

  @override
  State<MateriDetailScreen> createState() => _MateriDetailScreenState();
}

class _MateriDetailScreenState extends State<MateriDetailScreen> {
  // Menyimpan data bab materi aktif yang sedang dibaca siswa
  Map<String, dynamic>? _activeBabMateri;

  @override
  void initState() {
    super.initState();
    
    // 🛠️ PERBAIKAN UTAMA: Normalisasi singkatan kategori agar sinkron dengan ID dokumen di Firebase
    String kategoriNormal = widget.kategori.toUpperCase().trim();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CourseProvider>(context, listen: false).fetchMateri(kategoriNormal);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode; // <-- Panggil tema

    // KONDISI 1: JIKA BELUM PILIH BAB -> TAMPILKAN DAFTAR BAB MATERI DARI CLOUD
    if (_activeBabMateri == null) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFC), // <-- Latar belakang dinamis
        appBar: AppBar(
          elevation: 0,
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white, // <-- AppBar dinamis
          foregroundColor: isDark ? Colors.white : const Color(0xFF1E293B),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Materi ${widget.kategori}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: Consumer<CourseProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(widget.temaColor),
                ),
              );
            }

            final listMateri = provider.daftarMateri;

            if (listMateri.isEmpty) {
              return Center(
                child: Text(
                  "Materi belum tersedia untuk kategori ${widget.kategori}.",
                  style: TextStyle(color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: listMateri.length,
              itemBuilder: (context, index) {
                final bab = listMateri[index] as Map<String, dynamic>;
                final String nomorBab = "${index + 1}"; 
                final String judul = bab['judul_bab'] ?? "Tanpa Judul";

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white, // <-- Kartu bab dinamis
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        setState(() {
                          _activeBabMateri = bab;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: widget.temaColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  nomorBab,
                                  style: TextStyle(color: widget.temaColor, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    judul,
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Klik untuk mulai membaca modul",
                                    style: TextStyle(fontSize: 13, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1), size: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      );
    }

    // KONDISI 2: JIKA BAB DIPILIH -> PROSES & TAMPILKAN KONTEN BACAAN INTERAKTIF
    final String judulAktif = _activeBabMateri!['judul_bab'] ?? "Tanpa Judul";
    final String isiMateriRaw = _activeBabMateri!['isi_materi'] ?? "";
    final String urlMedia = _activeBabMateri!['url_media'] ?? "";

    List<Map<String, dynamic>> kontenDiproses = _parseMateriContent(isiMateriRaw);

    return BacaMateriScreen(
      kategori: widget.kategori,
      title: judulAktif,
      konten: kontenDiproses,
      urlMedia: urlMedia,
      temaColor: widget.temaColor,
      onBackToDaftar: () {
        setState(() {
          _activeBabMateri = null;
        });
      },
    );
  }

  // PARSER TEXT ENGINE (100% TIDAK DIUBAH)
  List<Map<String, dynamic>> _parseMateriContent(String rawText) {
    List<Map<String, dynamic>> blocks = [];
    List<String> lines = rawText.split('\n');
    
    String currentCode = "";
    String currentNote = "";
    bool inCode = false;
    bool inNote = false;

    for (String line in lines) {
      if (line.contains('[CODE]')) {
        inCode = true;
        currentCode = "${line.replaceAll('[CODE]', '')}\n";
        if (line.contains('[/CODE]')) {
          inCode = false;
          currentCode = currentCode.replaceAll('[/CODE]', '');
          blocks.add({'type': 'code', 'value': currentCode.trim()});
        }
        continue;
      }
      if (line.contains('[/CODE]')) {
        inCode = false;
        currentCode += line.replaceAll('[/CODE]', '');
        blocks.add({'type': 'code', 'value': currentCode.trim()});
        continue;
      }
      if (inCode) {
        currentCode += "$line\n";
        continue;
      }

      if (line.contains('[NOTE]')) {
        inNote = true;
        currentNote = "${line.replaceAll('[NOTE]', '')}\n";
        if (line.contains('[/NOTE]')) {
          inNote = false;
          currentNote = currentNote.replaceAll('[/NOTE]', '');
          blocks.add({'type': 'tip', 'value': currentNote.trim()});
        }
        continue;
      }
      if (line.contains('[/NOTE]')) {
        inNote = false;
        currentNote += line.replaceAll('[/NOTE]', '');
        blocks.add({'type': 'tip', 'value': currentNote.trim()});
        continue;
      }
      if (inNote) {
        currentNote += "$line\n";
        continue;
      }

      if (line.trim().startsWith('###')) {
        blocks.add({'type': 'header', 'value': line.replaceAll('###', '').trim()});
      } else if (line.trim().isNotEmpty) {
        blocks.add({'type': 'text', 'value': line.trim()});
      }
    }
    return blocks;
  }
}

class BacaMateriScreen extends StatefulWidget {
  final String kategori;
  final String title;
  final List<Map<String, dynamic>> konten;
  final String urlMedia;
  final Color temaColor;
  final VoidCallback onBackToDaftar;

  const BacaMateriScreen({
    Key? key,
    required this.kategori,
    required this.title,
    required this.konten,
    required this.urlMedia,
    required this.temaColor,
    required this.onBackToDaftar,
  }) : super(key: key);

  @override
  State<BacaMateriScreen> createState() => _BacaMateriScreenState();
}

class _BacaMateriScreenState extends State<BacaMateriScreen> {
  bool _isSelesaiDibaca = false;

  void _tampilkanDialogSukses(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
        return Dialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.temaColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    color: widget.temaColor,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Luar Biasa! 🎉",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1E293B)),
                ),
                const SizedBox(height: 10),
                Text(
                  "Kamu telah menyelesaikan bab\n\"${widget.title}\".\n\nSatu langkah lebih dekat untuk menguasai ${widget.kategori}!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B), height: 1.5),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.temaColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context); 
                      widget.onBackToDaftar(); 
                    },
                    child: const Text(
                      "Keren, Lanjutkan!",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode; // <-- Panggil tema

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8F9FA), // <-- Latar belakang bacaan dinamis
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white, // <-- AppBar dinamis
        foregroundColor: isDark ? Colors.white : const Color(0xFF0F172A),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: widget.onBackToDaftar,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: widget.konten.length + (widget.urlMedia.isNotEmpty ? 1 : 0),
              itemBuilder: (context, index) {
                if (widget.urlMedia.isNotEmpty && index == 0) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF064E3B) : const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? const Color(0xFF047857) : const Color(0xFFBBF7D0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.link_rounded, color: Color(0xFF16A34A)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Media Tambahan Pembelajaran:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: isDark ? const Color(0xFFA7F3D0) : const Color(0xFF14532D))),
                              Text(widget.urlMedia, style: const TextStyle(fontSize: 12, color: Color(0xFF16A34A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final itemIndex = widget.urlMedia.isNotEmpty ? index - 1 : index;
                final item = widget.konten[itemIndex];
                final String type = item['type'] ?? 'text';
                final String value = item['value'] ?? '';
                final String formattedValue = value.replaceAll(r'\n', '\n');

                if (type == 'header') {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      formattedValue,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF7A22)),
                    ),
                  );
                }

                if (type == 'note' || type == 'tip') {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF451A03) : const Color(0xFFFFF9E6), // <-- Kotak catatan dinamis
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? const Color(0xFF92400E) : const Color(0xFFFFE0B2)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFFFFB300), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            formattedValue, 
                            style: TextStyle(color: isDark ? const Color(0xFFFDE68A) : const Color(0xFFB71C1C), fontSize: 13, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (type == 'code') {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9), // <-- Kotak kode dinamis
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        formattedValue,
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          color: Color(0xFF3B82F6),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    formattedValue,
                    style: TextStyle(fontSize: 14, color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF334155), height: 1.6), // <-- Teks materi dinamis
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white, // <-- Bottom bar dinamis
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                )
              ],
              border: Border(top: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSelesaiDibaca ? const Color(0xFF94A3B8) : widget.temaColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  setState(() {
                    _isSelesaiDibaca = true;
                  });
                  _tampilkanDialogSukses(context);
                },
                icon: Icon(
                  _isSelesaiDibaca ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  _isSelesaiDibaca ? "Selesai Membaca" : "Saya Selesai Membaca",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
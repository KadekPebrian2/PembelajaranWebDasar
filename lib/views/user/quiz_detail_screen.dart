import 'package:flutter/material.dart';

class QuizDetailScreen extends StatefulWidget {
  final String kategori; // HTML, CSS, atau JS
  final Color temaColor;

  const QuizDetailScreen({
    Key? key,
    required this.kategori,
    required this.temaColor,
  }) : super(key: key);

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  int _currentIndex = 0;
  int _score = 0;
  String? _selectedAnswer;
  
  String _activeIdBab = ""; 
  String _activeNamaBab = "";

  // Bank data soal terstruktur tetap sama
  final Map<String, Map<String, List<Map<String, dynamic>>>> _spesifikSoalRepository = {
    "HTML": {
      "1": [
        {
          "soal": "Apa kepanjangan dari singkatan HTML?",
          "opsi": ["Hyper Text Markup Language", "Home Tool Markup Language", "Hyperlinks and Text Markup Language", "Hyper Tech Making Language"],
          "jawaban": "Hyper Text Markup Language"
        },
        {
          "soal": "Siapa yang mengembangkan standar utama bahasa HTML?",
          "opsi": ["Google", "Microsoft", "The World Wide Web Consortium (W3C)", "Mozilla"],
          "jawaban": "The World Wide Web Consortium (W3C)"
        }
      ],
      "2": [
        {
          "soal": "Tag HTML manakah yang membungkus seluruh konten visual yang tampil di browser?",
          "opsi": ["<head>", "<meta>", "<body>", "<title>"],
          "jawaban": "<body>"
        },
        {
          "soal": "Karakter apa yang wajib digunakan untuk menandakan sebuah tag penutup HTML?",
          "opsi": ["*", "/", "<", "^"],
          "jawaban": "/"
        }
      ],
      "3": [
        {
          "soal": "Tag HTML manakah yang digunakan untuk membuat judul (heading) terbesar?",
          "opsi": ["<heading>", "<h6>", "<head>", "<h1>"],
          "jawaban": "<h1>"
        }
      ],
    },
    "CSS": {
      "1": [
        {
          "soal": "Apa kepanjangan dari CSS?",
          "opsi": ["Computer Style Sheets", "Creative Style Sheets", "Cascading Style Sheets", "Colorful Style Sheets"],
          "jawaban": "Cascading Style Sheets"
        }
      ],
    },
    "JS": {
      "1": [
        {
          "soal": "Di dalam tag HTML mana kita meletakkan kode script JavaScript internal?",
          "opsi": ["<script>", "<javascript>", "<js>", "<scripting>"],
          "jawaban": "<script>"
        }
      ],
    }
  };

  // Subtitle kuis untuk pelengkap informasi di bawah judul utama
  String _getDeskripsiBabManual(String kategori, String id) {
    if (kategori == "HTML") {
      if (id == "1") return "Uji pemahaman kerangka dasar";
      if (id == "2") return "Uji pemahaman struktur tag dokumen";
      if (id == "3") return "Uji pemahaman tag heading website";
    } else if (kategori == "CSS") {
      if (id == "1") return "Uji pemahaman sintaks dasar & selektor";
    } else if (kategori == "JS") {
      if (id == "1") return "Uji pemahaman logika dasar script";
    }
    return "Latihan soal kuis kemampuan";
  }

  String _getLogoPath(String kategori) {
    switch (kategori.toUpperCase()) {
      case 'HTML': return 'assets/images/html_logo.png';
      case 'CSS':  return 'assets/images/css_logo.png';
      case 'JS':   return 'assets/images/js_logo.png';
      default:     return 'assets/images/html_logo.png';
    }
  }

  Color _getLogoBgColor(String kategori) {
    switch (kategori.toUpperCase()) {
      case 'HTML': return const Color(0xFFFFF0E5);
      case 'CSS':  return const Color(0xFFEBF4FF);
      case 'JS':   return const Color(0xFFFFF7E5);
      default:     return const Color(0xFFFFF0E5);
    }
  }

  void _nextQuestion(List<Map<String, dynamic>> daftarSoal) {
    if (_selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Silakan pilih salah satu jawaban dulu!"),
          backgroundColor: widget.temaColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    if (_selectedAnswer == daftarSoal[_currentIndex]['jawaban']) {
      _score += 100 ~/ daftarSoal.length;
    }

    if (_currentIndex < daftarSoal.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    bool isLulus = _score >= 70;
    String pesan = isLulus ? "Luar Biasa! 🎉" : "Tetap Semangat! 💪";
    Color iconColor = isLulus ? const Color(0xFF16A34A) : const Color(0xFFD97706);
    Color bgColor = isLulus ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7);
    IconData iconData = isLulus ? Icons.emoji_events_rounded : Icons.star_half_rounded;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                  child: Icon(iconData, color: iconColor, size: 40),
                ),
                const SizedBox(height: 20),
                Text(
                  pesan,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 8),
                Text(
                  "Hasil Kuis: $_activeNamaBab",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 16),
                const Text("Skor Kamu:", style: TextStyle(fontSize: 14, color: Color(0xFF475569))),
                Text(
                  "$_score",
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: widget.temaColor),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.temaColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _activeIdBab = "";
                        _currentIndex = 0;
                        _score = 0;
                        _selectedAnswer = null;
                      });
                    },
                    child: const Text(
                      "Selesai",
                      style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
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
    final kategoriMap = _spesifikSoalRepository[widget.kategori] ?? {};

    // KONDISI 1: JIKA BELUM PILIH KUIS -> TAMPILKAN LIST KUIS 1, KUIS 2, KUIS 3 DENGAN BADGE KOTAK ROUNDED
    if (_activeIdBab.isEmpty) {
      final keysBab = kategoriMap.keys.toList();

      return Scaffold(
        backgroundColor: const Color(0xFFF9FAFC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Daftar Kuis ${widget.kategori}",
            style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: keysBab.isEmpty
            ? const Center(child: Text("Soal belum tersedia untuk kategori ini."))
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                itemCount: keysBab.length,
                itemBuilder: (context, index) {
                  final idBab = keysBab[index];
                  // REVISI: Mengubah judul menjadi format seragam "Kuis 1", "Kuis 2", dst.
                  final namaKuisDinamis = "Kuis $idBab";
                  final deskripsiBab = _getDeskripsiBabManual(widget.kategori, idBab);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          setState(() {
                            _activeIdBab = idBab;
                            _activeNamaBab = namaKuisDinamis;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            children: [
                              // REVISI: Mengubah lingkaran menjadi kotak sedikit melengkung di pojoknya (Rounded Container)
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: widget.temaColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12), // Lengkungan sudut kotak halus
                                ),
                                child: Center(
                                  child: Text(
                                    idBab,
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
                                      namaKuisDinamis,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      deskripsiBab,
                                      style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFCBD5E1), size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      );
    }

    // KONDISI 2: JALANKAN GAMEPLAY KUIS SEPERTI BIASA
    final List<Map<String, dynamic>> listSoal = List<Map<String, dynamic>>.from(kategoriMap[_activeIdBab]!);
    final soalAktif = listSoal[_currentIndex];
    double progress = (_currentIndex + 1) / listSoal.length;
    String logoPath = _getLogoPath(widget.kategori);
    Color logoBgColor = _getLogoBgColor(widget.kategori);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E293B), size: 20),
          onPressed: () {
            setState(() {
              _activeIdBab = ""; 
            });
          },
        ),
        title: const Text(
          "Kuis",
          style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: logoBgColor, borderRadius: BorderRadius.circular(16)),
                    child: Image.asset(logoPath, fit: BoxFit.contain),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Modul ${widget.kategori}",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: widget.temaColor, letterSpacing: 0.5),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _activeNamaBab,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pertanyaan ${_currentIndex + 1} dari ${listSoal.length}",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFFE2E8F0),
                color: widget.temaColor,
                minHeight: 8,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 6))],
                ),
                child: Text(
                  soalAktif['soal'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF0F172A), height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: ListView(
                  children: soalAktif['opsi'].map<Widget>((opsiTeks) {
                    final bool isSelected = _selectedAnswer == opsiTeks;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAnswer = opsiTeks;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected ? widget.temaColor.withValues(alpha: 0.1) : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: isSelected ? widget.temaColor : const Color(0xFFE2E8F0), width: isSelected ? 2 : 1.5),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: isSelected ? widget.temaColor : const Color(0xFFCBD5E1), width: 2),
                                color: isSelected ? widget.temaColor : Colors.transparent,
                              ),
                              child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                opsiTeks,
                                style: TextStyle(fontSize: 15, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? widget.temaColor : const Color(0xFF334155)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedAnswer != null ? widget.temaColor : const Color(0xFFCBD5E1),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () => _nextQuestion(listSoal),
                  child: Text(
                    _currentIndex == listSoal.length - 1 ? "Submit Nilai" : "Soal Berikutnya",
                    style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
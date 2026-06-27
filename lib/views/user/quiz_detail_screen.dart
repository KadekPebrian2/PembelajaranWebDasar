import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/course_provider.dart';
import '../../providers/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';

class QuizDetailScreen extends StatefulWidget {
  final String kategori;
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
  Map<String, dynamic>? _activePaketQuiz;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CourseProvider>(context, listen: false)
          .fetchPaketKuis(widget.kategori);
    });
  }

  // === FUNGSI PENGAMAN TIPE DATA ===
  String _getStringAman(dynamic data, String fallback) {
    if (data == null) return fallback;
    if (data is List) return data.isNotEmpty ? data.first.toString() : fallback;
    return data.toString();
  }

  String _getLogoPath(String kategori) {
    switch (kategori.toUpperCase()) {
      case 'HTML':
        return 'assets/images/html_logo.png';
      case 'CSS':
        return 'assets/images/css_logo.png';
      case 'JS':
        return 'assets/images/js_logo.png';
      default:
        return 'assets/images/html_logo.png';
    }
  }

  Color _getLogoBgColor(String kategori) {
    switch (kategori.toUpperCase()) {
      case 'HTML':
        return const Color(0xFFFFF0E5);
      case 'CSS':
        return const Color(0xFFEBF4FF);
      case 'JS':
        return const Color(0xFFFFF7E5);
      default:
        return const Color(0xFFFFF0E5);
    }
  }

  void _nextQuestion(List<dynamic> daftarSoal) {
    if (_selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text("Silakan pilih salah satu jawaban dulu!"),
            backgroundColor: widget.temaColor,
            behavior: SnackBarBehavior.floating),
      );
      return;
    }

    final soalAktif = daftarSoal[_currentIndex];
    final jawabanBenar = _getStringAman(
            soalAktif['jawaban_benar'] ??
                soalAktif['jawaban'] ??
                soalAktif['correct_answer'],
            '')
        .trim();

    if (_selectedAnswer?.trim() == jawabanBenar) {
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

  // 🔥 PERBAIKAN: Ditambahkan kata kunci 'async' di bawah ini agar 'await' bisa berjalan
  void _showResultDialog() async {
    bool isLulus = _score >= 70;
    String pesan = isLulus ? "Luar Biasa! 🎉" : "Tetap Semangat! 💪";
    Color iconColor =
        isLulus ? const Color(0xFF16A34A) : const Color(0xFFD97706);
    Color bgColor = isLulus ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7);

    String namaKuis = _getStringAman(
        _activePaketQuiz?["nama_kuis"] ?? _activePaketQuiz?["id"], "Kuis");
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final currentUserEmail =
        authProv.currentUser?.email ?? 'anonim@weblearn.com';

    try {
      await FirebaseFirestore.instance.collection('user_results').add({
        'email': currentUserEmail,
        'kategori': widget.kategori,
        'nama_kuis': namaKuis,
        'skor': _score,
        'timestamp': FieldValue.serverTimestamp(),
      });
      debugPrint("🚀 Skor riil berhasil dikirim ke Cloud Firestore!");
    } catch (e) {
      debugPrint("❌ Gagal mengirim skor riil: $e");
    }

    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final isDark = Provider.of<ThemeProvider>(context, listen: false)
            .isDarkMode; // <-- Cek tema dialog
        return Dialog(
          backgroundColor: isDark
              ? const Color(0xFF1E293B)
              : Colors.white, // <-- Background dialog dinamis
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration:
                      BoxDecoration(color: bgColor, shape: BoxShape.circle),
                  child: Icon(
                      isLulus
                          ? Icons.emoji_events_rounded
                          : Icons.star_half_rounded,
                      color: iconColor,
                      size: 40),
                ),
                const SizedBox(height: 20),
                Text(pesan,
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color:
                            isDark ? Colors.white : const Color(0xFF0F172A))),
                const SizedBox(height: 8),
                Text("Hasil Kuis: $namaKuis",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B))),
                const SizedBox(height: 16),
                Text("Skor Kamu:",
                    style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? const Color(0xFFCBD5E1)
                            : const Color(0xFF475569))),
                Text("$_score",
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: widget.temaColor)),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: widget.temaColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _activePaketQuiz = null;
                        _currentIndex = 0;
                        _score = 0;
                        _selectedAnswer = null;
                      });
                    },
                    child: const Text("Selesai",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
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
    final isDark =
        Provider.of<ThemeProvider>(context).isDarkMode; // <-- Panggil tema

    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        // Mencegah Kuis Tertukar saat Update Realtime
        if (_activePaketQuiz != null && provider.daftarPaketQuiz.isNotEmpty) {
          final matchedQuiz = provider.daftarPaketQuiz
              .where((paket) => paket['id'] == _activePaketQuiz!['id'])
              .toList();
          if (matchedQuiz.isNotEmpty) {
            _activePaketQuiz = matchedQuiz.first;
          }
        }

        // --- TAMPILAN MENU DAFTAR KUIS ---
        if (_activePaketQuiz == null) {
          return Scaffold(
            backgroundColor: isDark
                ? const Color(0xFF0F172A)
                : const Color(0xFFF9FAFC), // <-- Latar belakang dinamis
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_new_rounded,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      size: 20),
                  onPressed: () => Navigator.pop(context)),
              title: Text("Daftar Kuis ${widget.kategori}",
                  style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ),
            body: provider.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(widget.temaColor)))
                : provider.daftarPaketQuiz.isEmpty
                    ? Center(
                        child: Text(
                            "Soal belum tersedia untuk kategori ${widget.kategori}.",
                            style: TextStyle(
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                                fontSize: 14)))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        itemCount: provider.daftarPaketQuiz.length,
                        itemBuilder: (context, index) {
                          final paket = provider.daftarPaketQuiz[index];
                          final String namaKuis = _getStringAman(
                              paket["nama_kuis"] ?? paket["id"], "Kuis");
                          final List<dynamic> soalList =
                              paket["soal_list"] is List
                                  ? paket["soal_list"]
                                  : [];

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : Colors
                                      .white, // <-- Kartu daftar kuis dinamis
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black
                                        .withValues(alpha: isDark ? 0.2 : 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4))
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  if (soalList.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Kuis ini belum memiliki pertanyaan.")));
                                    return;
                                  }
                                  setState(() {
                                    _activePaketQuiz = paket;
                                    _currentIndex = 0;
                                    _score = 0;
                                    _selectedAnswer = null;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 44,
                                        height: 44,
                                        decoration: BoxDecoration(
                                            color: widget.temaColor
                                                .withValues(alpha: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Center(
                                            child: Icon(
                                                Icons.assignment_rounded,
                                                color: widget.temaColor,
                                                size: 22)),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(namaKuis,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: isDark
                                                        ? Colors.white
                                                        : const Color(
                                                            0xFF0F172A))),
                                            const SizedBox(height: 4),
                                            Text(
                                                "${soalList.length} Pertanyaan",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: isDark
                                                        ? const Color(
                                                            0xFF94A3B8)
                                                        : const Color(
                                                            0xFF64748B))),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.arrow_forward_ios_rounded,
                                          color: isDark
                                              ? const Color(0xFF475569)
                                              : const Color(0xFFCBD5E1),
                                          size: 16),
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

        // --- TAMPILAN GAMEPLAY KUIS ---
        List<dynamic> listSoal = _activePaketQuiz!["soal_list"] is List
            ? _activePaketQuiz!["soal_list"]
            : [];

        if (listSoal.isEmpty || _currentIndex >= listSoal.length) {
          return Scaffold(
            backgroundColor:
                isDark ? const Color(0xFF0F172A) : const Color(0xFFF9FAFC),
            appBar: AppBar(title: const Text("Kuis")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Kuis sedang diperbarui oleh Admin.",
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () => setState(() => _activePaketQuiz = null),
                      child: const Text("Kembali")),
                ],
              ),
            ),
          );
        }

        final soalAktif = listSoal[_currentIndex];
        double progress = (_currentIndex + 1) / listSoal.length;

        final String teksPertanyaan = _getStringAman(
            soalAktif['soal'] ?? soalAktif['pertanyaan'], "Pertanyaan kosong");

        List<String> opsiJawaban = [];
        if (soalAktif['opsi'] is List) {
          opsiJawaban =
              (soalAktif['opsi'] as List).map((e) => e.toString()).toList();
        } else if (soalAktif['pilihan'] is List) {
          opsiJawaban =
              (soalAktif['pilihan'] as List).map((e) => e.toString()).toList();
        } else {
          if (soalAktif['a'] != null)
            opsiJawaban.add(soalAktif['a'].toString());
          if (soalAktif['b'] != null)
            opsiJawaban.add(soalAktif['b'].toString());
          if (soalAktif['c'] != null)
            opsiJawaban.add(soalAktif['c'].toString());
          if (soalAktif['d'] != null)
            opsiJawaban.add(soalAktif['d'].toString());
        }

        String labelNamaKuisHeader = _getStringAman(
            _activePaketQuiz!["nama_kuis"] ?? _activePaketQuiz!["id"], "Kuis");

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF0F172A)
              : const Color(0xFFF9FAFC), // <-- Latar belakang soal dinamis
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                  size: 20),
              onPressed: () => setState(() {
                _activePaketQuiz = null;
                _currentIndex = 0;
                _score = 0;
                _selectedAnswer = null;
              }),
            ),
            title: Text("Kuis",
                style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
          ),
          body: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : _getLogoBgColor(widget.kategori),
                            borderRadius: BorderRadius.circular(16)),
                        child: Image.asset(_getLogoPath(widget.kategori),
                            fit: BoxFit.contain),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Modul ${widget.kategori}",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: widget.temaColor,
                                    letterSpacing: 0.5)),
                            const SizedBox(height: 4),
                            Text(labelNamaKuisHeader,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF0F172A)),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                      "Pertanyaan ${_currentIndex + 1} dari ${listSoal.length}",
                      style: TextStyle(
                          fontFamily: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.fontFamily,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B))),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                      value: progress,
                      backgroundColor: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                      color: widget.temaColor,
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(10)),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black
                                  .withValues(alpha: isDark ? 0.2 : 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 6))
                        ]),
                    child: Text(teksPertanyaan,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color:
                                isDark ? Colors.white : const Color(0xFF0F172A),
                            height: 1.5),
                        textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 30),
                  Expanded(
                    child: ListView(
                      children: opsiJawaban.map<Widget>((opsiTeks) {
                        final bool isSelected = _selectedAnswer == opsiTeks;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedAnswer = opsiTeks),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? widget.temaColor.withValues(alpha: 0.15)
                                  : (isDark
                                      ? const Color(0xFF1E293B)
                                      : Colors.white),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                  color: isSelected
                                      ? widget.temaColor
                                      : (isDark
                                          ? const Color(0xFF334155)
                                          : const Color(0xFFE2E8F0)),
                                  width: isSelected ? 2 : 1.5),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: isSelected
                                              ? widget.temaColor
                                              : (isDark
                                                  ? const Color(0xFF64748B)
                                                  : const Color(0xFFCBD5E1)),
                                          width: 2),
                                      color: isSelected
                                          ? widget.temaColor
                                          : Colors.transparent),
                                  child: isSelected
                                      ? const Icon(Icons.check,
                                          size: 16, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                    child: Text(opsiTeks,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            color: isSelected
                                                ? widget.temaColor
                                                : (isDark
                                                    ? const Color(0xFFE2E8F0)
                                                    : const Color(
                                                        0xFF334155))))),
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
                          backgroundColor: _selectedAnswer != null
                              ? widget.temaColor
                              : (isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFCBD5E1)),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14))),
                      onPressed: () => _nextQuestion(listSoal),
                      child: Text(
                          _currentIndex == listSoal.length - 1
                              ? "Submit Nilai"
                              : "Soal Berikutnya",
                          style: TextStyle(
                              color: _selectedAnswer != null
                                  ? Colors.white
                                  : Colors.grey[400],
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

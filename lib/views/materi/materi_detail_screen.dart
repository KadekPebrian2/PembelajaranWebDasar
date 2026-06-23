import 'package:flutter/material.dart';

class MateriDetailScreen extends StatefulWidget {
  final String kategori;
  final String title;
  final List<Map<String, dynamic>> konten;
  final Color temaColor;

  const MateriDetailScreen({
    Key? key, // PERBAIKAN: Ditambahkan tanda tanya (?) agar tidak error null safety
    required this.kategori,
    required this.title,
    required this.konten,
    required this.temaColor,
  }) : super(key: key);

  @override
  State<MateriDetailScreen> createState() => _MateriDetailScreenState();
}

class _MateriDetailScreenState extends State<MateriDetailScreen> {
  bool _isSelesaiDibaca = false;

  // FUNGSIONAL POP-UP DIALOG APRESIASI MENARIK & AUTO CLOSE
  void _tampilkanDialogSukses(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ikon Apresiasi Menarik
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.temaColor.withValues(alpha: 0.1), // PERBAIKAN: Menggunakan .withValues()
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.emoji_events_rounded,
                    color: widget.temaColor,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Luar Biasa! 🎉",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 10),
                Text(
                  "Kamu telah menyelesaikan bab\n\"${widget.title}\".\n\nSatu langkah lebih dekat untuk menguasai ${widget.kategori}!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.5),
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
                      Navigator.pop(context); // Tutup Pop-up Dialog
                      Navigator.pop(context); // Keluar dari Halaman Materi
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
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: widget.konten.length,
              itemBuilder: (context, index) {
                final item = widget.konten[index];
                final String type = item['type'] ?? 'text';
                final String value = item['value'] ?? '';

                if (type == 'header') {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: widget.temaColor),
                    ),
                  );
                }
                
                if (type == 'tip') {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1), // PERBAIKAN: Menggunakan .withValues()
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Text(value, style: TextStyle(color: Colors.amber.shade900, fontSize: 13, height: 1.5)),
                  );
                }

                if (type == 'code') {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9), 
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)), 
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontFamily: 'monospace', 
                          color: Color(0xFF334155), 
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
                    value,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF334155), height: 1.6),
                  ),
                );
              },
            ),
          ),
          
          // TOMBOL UTAMA SAYA SELESAI MEMBACA
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04), // PERBAIKAN: Menggunakan .withValues()
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                )
              ],
              border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
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
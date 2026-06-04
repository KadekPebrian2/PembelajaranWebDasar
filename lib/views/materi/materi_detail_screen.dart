import 'package:flutter/material.dart';

class MateriDetailScreen extends StatelessWidget {
  final String title;
  final String content;
  final Color colorTheme;

  const MateriDetailScreen({
    Key? key,
    required this.title,
    required this.content,
    required this.colorTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: colorTheme,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorTheme,
              ),
            ),
            const SizedBox(height: 20),
            // Teks Materi Utama
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6, // Jarak antar baris agar nyaman dibaca
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40),
            // Tombol Selesai Membaca
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorTheme,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // Kembali ke list
                },
                child: const Text(
                  "Selesai Membaca",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
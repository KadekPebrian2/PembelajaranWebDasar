import 'package:flutter/material.dart';

class MateriDetailScreen extends StatelessWidget {
  final String kategori;
  final String title;
  final List<Map<String, dynamic>> konten;
  final Color temaColor;

  const MateriDetailScreen({
    Key? key,
    required this.kategori,
    required this.title,
    required this.konten,
    required this.temaColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title, 
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: temaColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFF8F9FA),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: konten.length,
        itemBuilder: (context, index) {
          final item = konten[index];
          final type = item['type'];
          final value = item['value'] ?? '';

          if (type == 'header') {
            return Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 8),
              child: Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: temaColor),
              ),
            );
          } else if (type == 'text') {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                value,
                style: const TextStyle(fontSize: 14, color: Color(0xFF334155), height: 1.6),
              ),
            );
          } else if (type == 'code') {
            // PERBAIKAN: Tidak menggunakan background gelap lagi
            return Container(
              margin: const EdgeInsets.only(bottom: 16, top: 4),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              width: double.infinity,
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 13,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          } else if (type == 'tip') {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: temaColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: temaColor.withValues(alpha: 0.3), width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lightbulb, color: temaColor, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 13, color: temaColor, height: 1.4, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
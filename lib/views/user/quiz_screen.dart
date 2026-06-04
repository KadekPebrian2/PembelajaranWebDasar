import 'package:flutter/material.dart';
import '../../core/theme.dart';

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quiz Interaktif"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildQuizCard(context, "Quiz HTML Dasar", "5 Soal • 10 Menit", AppTheme.orangeAccent),
          _buildQuizCard(context, "Quiz CSS Layout", "5 Soal • 10 Menit", Colors.blue),
          _buildQuizCard(context, "Quiz JavaScript DOM", "5 Soal • 15 Menit", Colors.amber),
        ],
      ),
    );
  }

  Widget _buildQuizCard(BuildContext context, String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, spreadRadius: 2)],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(Icons.quiz, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            // Navigasi ke QuizDetailScreen yang sudah dibuat sebelumnya
          },
          child: const Text("Mulai", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
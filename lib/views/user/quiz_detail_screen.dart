import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/weblearn_models.dart';

class QuizDetailScreen extends StatefulWidget {
  final Kuis kuis;
  const QuizDetailScreen({Key? key, required this.kuis}) : super(key: key);

  @override
  _QuizDetailScreenState createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  String? selectedOpt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kuis", style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.orangeAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 5)],
              ),
              child: Text(widget.kuis.pertanyaan, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            _buildOption("A", widget.kuis.optA),
            _buildOption("B", widget.kuis.optB),
            _buildOption("C", widget.kuis.optC),
            _buildOption("D", widget.kuis.optD),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String key, String text) {
    bool isSelected = selectedOpt == key;
    return GestureDetector(
      onTap: () => setState(() => selectedOpt = key),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: isSelected ? Colors.green : Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
              child: Text(key, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 15),
            Expanded(child: Text(text)),
            if (isSelected) const Icon(Icons.check_circle, color: Colors.green)
          ],
        ),
      ),
    );
  }
}
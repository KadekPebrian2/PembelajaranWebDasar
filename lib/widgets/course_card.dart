import 'package:flutter/material.dart';
import '../core/theme.dart';

class CourseCard extends StatelessWidget {
  final String title;
  final String description;
  final double progressValue; // Nilai antara 0.0 sampai 1.0
  final IconData iconData;
  final Color accentColor;
  final VoidCallback onTap;

  const CourseCard({
    Key? key,
    required this.title,
    required this.description,
    required this.progressValue,
    required this.iconData,
    this.accentColor = AppTheme.primaryPurple,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final int percentage = (progressValue * 100).toInt();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Atas Card (Header Warna)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: accentColor,
                  child: Icon(iconData, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppTheme.textDark,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Bagian Bawah Card (Progres & Tombol Aksi)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Progress Belajar",
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                    ),
                    Text(
                      "$percentage%",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: accentColor),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    minHeight: 8,
                    backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                  ),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: accentColor.withOpacity(0.5), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: onTap,
                    child: Text(
                      "Lanjut Belajar",
                      style: TextStyle(color: accentColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
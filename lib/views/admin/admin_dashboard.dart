import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text("Statistik Sistem", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildStatCard("Modul HTML", "5", AppTheme.orangeAccent)),
              const SizedBox(width: 15),
              Expanded(child: _buildStatCard("Modul CSS", "5", Colors.blue)),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(child: _buildStatCard("Modul JS", "5", Colors.amber)),
              const SizedBox(width: 15),
              Expanded(child: _buildStatCard("Total Kuis", "15", AppTheme.primaryPurple)),
            ],
          ),
          const SizedBox(height: 30),
          const Text("Menu Kelola", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          _buildAdminMenu(Icons.menu_book, "Kelola Materi", () {}),
          _buildAdminMenu(Icons.quiz, "Kelola Quiz", () {}),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Text(count, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 5),
          Text(title, style: TextStyle(fontSize: 14, color: Colors.grey.shade800)),
        ],
      ),
    );
  }

  Widget _buildAdminMenu(IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: BorderSide(color: Colors.grey.shade200)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(backgroundColor: AppTheme.primaryPurple.withOpacity(0.1), child: Icon(icon, color: AppTheme.primaryPurple)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
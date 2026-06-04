import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  // Variabel untuk menyimpan data user yang sedang login
  Map<String, dynamic>? _currentUser;

  // Getter untuk mengambil data user
  Map<String, dynamic>? get currentUser => _currentUser;

  // Fungsi saat user berhasil login
  void login(Map<String, dynamic> userData) {
    _currentUser = userData;
    notifyListeners(); // Memberi tahu semua halaman untuk update UI
  }

  // Fungsi saat user logout
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
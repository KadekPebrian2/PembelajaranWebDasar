import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  User? _firebaseUser;
  User? get currentUser => _firebaseUser; 
  bool get isAuthenticated => _firebaseUser != null;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _firebaseUser = user;
      notifyListeners(); 
    });
  }

  // Fungsi Login (100% Tidak Diubah)
  Future<Map<String, dynamic>?> loginWithFirebase(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _firebaseUser = userCredential.user;
      notifyListeners();

      String role = 'user';
      try {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(_firebaseUser!.uid).get();
        if (userDoc.exists) {
          role = userDoc['role'] ?? 'user';
          print("Role dari database: $role");
        }
      } catch (e) {
        print("Error mengambil role: $e");
      }

      return {
        'uid': _firebaseUser!.uid,
        'email': _firebaseUser!.email,
        'role': role,
      };
    } catch (e) {
      print("General Login Error: $e");
      return null;
    }
  }

  // 🔥 PERBAIKAN: Fungsi Register sekarang otomatis membuat dokumen di Firestore 'users'
  Future<bool> registerWithFirebase(String email, String password, String nama) async {
    try {
      // 1. Buat akun di Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
      );

      User? user = userCredential.user;

      if (user != null) {
        // Update display name di profil Authentication bawaan
        await user.updateDisplayName(nama);

        // 2. KUNCI: Otomatis buat dokumen baru di koleksi 'users' menggunakan UID
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'nama': nama,
          'email': email,
          'role': 'user', // Otomatis jadi siswa biasa
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return true; 
    } catch (e) {
      print("General Register Error: $e");
      return false;
    }
  }

  // 🔥 PERBAIKAN: Menambahkan fungsi Logout agar tombol keluar di profil tidak eror
  Future<void> logout() async {
    await _auth.signOut();
    _firebaseUser = null;
    notifyListeners();
  }

  Future<void> logoutWithFirebase() async {
    await logout();
  }
}
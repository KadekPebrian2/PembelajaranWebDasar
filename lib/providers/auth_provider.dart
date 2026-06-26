import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; // <-- WAJIB: Tambahkan import Firestore

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // <-- Tambahkan instance Firestore
  
  User? _firebaseUser;
  User? get currentUser => _firebaseUser;
  bool get isAuthenticated => _firebaseUser != null;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _firebaseUser = user;
      notifyListeners(); 
    });
  }

  // ==========================================
  // 1. FUNGSI LOGIN MENGGUNAKAN FIREBASE (SUDAH DIPERBAIKI)
  // ==========================================
  Future<Map<String, dynamic>?> loginWithFirebase(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      _firebaseUser = userCredential.user;
      notifyListeners();

      // --- AKSI BARU: Ambil Role dari Cloud Firestore ---
      String role = 'user'; // Anggap user biasa sebagai nilai awal (default)
      
      try {
        // Cari dokumen user di Firestore berdasarkan UID
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(_firebaseUser!.uid).get();
        
        // Jika dokumennya ada di Firestore, ambil isi field 'role'
        if (userDoc.exists) {
          role = userDoc['role'] ?? 'user';
          print("Role dari database: $role");
        } else {
          print("Dokumen user tidak ditemukan di Firestore, masuk sebagai user biasa.");
        }
      } catch (e) {
        print("Error mengambil role dari Firestore: $e");
      }

      // Kembalikan data lengkap ke login_screen.dart
      return {
        'uid': _firebaseUser!.uid,
        'email': _firebaseUser!.email,
        'role': role, // <-- Sekarang role bergantung pada data di Firestore!
      };
      
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code}");
      return null; 
    } catch (e) {
      print("General Login Error: $e");
      return null;
    }
  }

  // ==========================================
  // 2. FUNGSI DAFTAR (REGISTER) MENGGUNAKAN FIREBASE
  // ==========================================
  Future<bool> registerWithFirebase(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return true; 
    } on FirebaseAuthException catch (e) {
      print("Firebase Register Error: ${e.code}");
      return false; 
    } catch (e) {
      print("General Register Error: $e");
      return false;
    }
  }

  // ==========================================
  // 3. FUNGSI KELUAR (LOGOUT) DARI FIREBASE
  // ==========================================
  Future<void> logout() async {
    await _auth.signOut(); 
    _firebaseUser = null;
    notifyListeners(); 
  }
}
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class CourseProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- STATE UNTUK KUIS ---
  List<Map<String, dynamic>> _daftarPaketQuiz = [];
  List<Map<String, dynamic>> get daftarPaketQuiz => _daftarPaketQuiz;

  // --- STATE UNTUK MATERI ---
  List<Map<String, dynamic>> _daftarMateri = [];
  List<Map<String, dynamic>> get daftarMateri => _daftarMateri;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  StreamSubscription? _quizSubscription;
  StreamSubscription? _materiSubscription;

  void resetState() {
    _quizSubscription?.cancel();
    _materiSubscription?.cancel();
    _daftarPaketQuiz = [];
    _daftarMateri = [];
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _quizSubscription?.cancel();
    _materiSubscription?.cancel();
    super.dispose();
  }

  // ========================================================
  // MANAJEMEN KUIS (SINKRON DENGAN MULTI-PAKET DAFTAR_PAKET)
  // ========================================================
  void fetchPaketKuis(String kategori) {
    _isLoading = true;
    notifyListeners();

    _quizSubscription?.cancel();

    _quizSubscription = _firestore.collection('kuis').snapshots().listen((snapshot) {
      _daftarPaketQuiz = [];
      String targetKategori = kategori.toUpperCase().trim();
      
      for (var doc in snapshot.docs) {
        String docId = doc.id.toUpperCase().trim();
        
        // Cari dokumen kategori yang cocok (Misal: HTML)
        if (docId == targetKategori) {
          Map<String, dynamic> docData = doc.data();
          
          // AMBIL DARI FIELD 'daftar_paket' SESUAI KODE ADMIN
          if (docData['daftar_paket'] is List) {
            List<dynamic> listPaketDariAdmin = docData['daftar_paket'];
            
            for (int i = 0; i < listPaketDariAdmin.length; i++) {
              var paket = listPaketDariAdmin[i];
              if (paket is Map<String, dynamic>) {
                
                // Format agar UI User mengenali strukturnya dengan pas
                _daftarPaketQuiz.add({
                  'id': '${doc.id}_$i', // ID Unik gabungan kategori dan index paket
                  'nama_kuis': paket['judul_paket'] ?? 'Kuis ${i + 1}',
                  'soal_list': paket['pertanyaan'] is List ? paket['pertanyaan'] : [],
                });
                
                debugPrint("🎯 Paket Terbaca Sempurna: ${paket['judul_paket']} berisi ${(paket['pertanyaan'] as List).length} soal");
              }
            }
          }
        }
      }

      // BACKUP FALLBACK: Jika dokumen kategori ketemu tapi field daftar_paket kosong, cek struktur root lama
      if (_daftarPaketQuiz.isEmpty) {
        for (var doc in snapshot.docs) {
          if (doc.id.toUpperCase().trim() == targetKategori) {
            Map<String, dynamic> data = doc.data();
            List<dynamic> qs = [];
            if (data['pertanyaan'] is List) qs = data['pertanyaan'];
            else if (data['soal_list'] is List) qs = data['soal_list'];
            
            if (qs.isNotEmpty) {
              _daftarPaketQuiz.add({
                'id': doc.id,
                'nama_kuis': data['nama_kuis'] ?? data['judul_paket'] ?? doc.id,
                'soal_list': qs,
              });
            }
          }
        }
      }

      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      _isLoading = false;
      debugPrint("Error Kuis Real-time: $e");
      notifyListeners();
    });
  }

  Future<void> addSoalKuis(String namaKuis, String kategori, List<dynamic> soalList) async {
    try {
      await _firestore.collection('kuis').doc(kategori).set({
        "id": kategori,
        "nama_kuis": namaKuis,
        "kategori": kategori,
        "soal_list": List.from(soalList, growable: true),
      }, SetOptions(merge: true));
    } catch (e) { rethrow; }
  }

  Future<void> updateSoalKuis(String docId, List<dynamic> soalBaru) async {
    try {
      await _firestore.collection('kuis').doc(docId).update({
        "soal_list": List.from(soalBaru, growable: true),
      });
    } catch (e) { rethrow; }
  }

  // ==========================================
  // MANAJEMEN MATERI
  // ==========================================
  void fetchMateri(String kategori) {
    _isLoading = true;
    notifyListeners();

    _materiSubscription?.cancel();
    _materiSubscription = _firestore.collection('courses').doc(kategori).snapshots().listen((doc) {
      _daftarMateri = [];
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data["daftar_bab"] != null && data["daftar_bab"] is List) {
          _daftarMateri = List<Map<String, dynamic>>.from(data["daftar_bab"]);
        } else if (data["bab"] != null && data["bab"] is List) {
          _daftarMateri = List<Map<String, dynamic>>.from(data["bab"]);
        }
      }
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> updateMateri(String kategori, List<dynamic> babBaru) async {
    try {
      await _firestore.collection('courses').doc(kategori).set({
        "daftar_bab": List.from(babBaru, growable: true),
      }, SetOptions(merge: true));
    } catch (e) { rethrow; }
  }
}
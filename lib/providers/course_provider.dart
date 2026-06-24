import 'package:flutter/material.dart';

class CourseProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _daftarPaketQuiz = List.from([
    {
      "id": "1", 
      "nama_kuis": "Kuis 1: Pengenalan Dasar", 
      "soal_list": List.from([
        {"soal": "Apa kepanjangan dari HTML?", "a": "Hyper Text Markup Language", "b": "Hyper Link Text", "c": "Home Tool Markup", "d": "Hyper Tech", "jawaban_benar": "a"}
      ], growable: true)
    },
    {
      "id": "2", 
      "nama_kuis": "Kuis 2: Struktur & Tag Elemen", 
      "soal_list": List.from([
        {"soal": "Tag manakah yang digunakan untuk membuat baris baru?", "a": "<p>", "b": "<br>", "c": "<li>", "d": "<a>", "jawaban_benar": "b"}
      ], growable: true)
    },
  ], growable: true);

  List<Map<String, dynamic>> get daftarPaketQuiz => _daftarPaketQuiz;

  void tambahPaketKuis(String judul, List<Map<String, dynamic>> soal) {
    _daftarPaketQuiz.add({
      "id": "${_daftarPaketQuiz.length + 1}",
      "nama_kuis": judul,
      "soal_list": List.from(soal, growable: true),
    });
    notifyListeners();
  }

  void updateSoalKuis(int indeksPaket, List<dynamic> soalBaru) {
    _daftarPaketQuiz[indeksPaket]["soal_list"] = List.from(soalBaru, growable: true);
    notifyListeners(); 
  }
}
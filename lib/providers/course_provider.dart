import 'package:flutter/material.dart';
import '../core/database_helper.dart';
import '../models/weblearn_models.dart';

class CourseProvider with ChangeNotifier {
  List<Kategori> _kategoriList = [];
  List<Modul> _modulList = [];
  List<Kategori> get kategoriList => _kategoriList;
  List<Modul> get modulList => _modulList;

  CourseProvider() {
    fetchKategori();
  }

  Future<void> fetchKategori() async {
    final db = await DatabaseHelper.instance.database;
    final res = await db.query('kategori');
    _kategoriList = res.map((c) => Kategori.fromMap(c)).toList();
    notifyListeners();
  }

  Future<void> fetchModulByKategori(int kategoriId) async {
    final db = await DatabaseHelper.instance.database;
    final res = await db.query('modul', where: 'kategori_id = ?', whereArgs: [kategoriId], orderBy: 'order_index ASC');
    _modulList = res.map((m) => Modul.fromMap(m)).toList();
    notifyListeners();
  }

  Future<List<Kuis>> fetchKuisByModul(int modulId) async {
    final db = await DatabaseHelper.instance.database;
    final res = await db.query('kuis', where: 'modul_id = ?', whereArgs: [modulId]);
    return res.map((q) => Kuis.fromMap(q)).toList();
  }
}
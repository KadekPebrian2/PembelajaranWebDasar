import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('weblearn.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // 0. TABEL USERS (BARU: Untuk sistem Login & Register)
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL
      )
    ''');

    // 1. Kategori
    await db.execute('''
      CREATE TABLE kategori (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        deskripsi TEXT
      )
    ''');

    // 2. Modul
    await db.execute('''
      CREATE TABLE modul (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kategori_id INTEGER,
        judul TEXT,
        order_index INTEGER,
        FOREIGN KEY(kategori_id) REFERENCES kategori(id)
      )
    ''');

    // 3. Konten
    await db.execute('''
      CREATE TABLE konten (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        modul_id INTEGER,
        penjelasan_materi TEXT,
        cuplikan_kode TEXT,
        penjelasan_kode TEXT,
        FOREIGN KEY(modul_id) REFERENCES modul(id)
      )
    ''');

    // 4. Kuis
    await db.execute('''
      CREATE TABLE kuis (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        modul_id INTEGER,
        pertanyaan TEXT,
        opt_a TEXT,
        opt_b TEXT,
        opt_c TEXT,
        opt_d TEXT,
        jawaban TEXT,
        FOREIGN KEY(modul_id) REFERENCES modul(id)
      )
    ''');

    // 5. User Progress
    await db.execute('''
      CREATE TABLE user_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        modul_id INTEGER,
        is_completed INTEGER DEFAULT 0,
        last_accessed DATETIME,
        FOREIGN KEY(modul_id) REFERENCES modul(id)
      )
    ''');

    // Seed Initial Data
    await _seedData(db);
  }

  Future _seedData(Database db) async {
    // --- SEED AKUN DEFAULT ---
    // Akun khusus Admin
    await db.insert('users', {
      'nama': 'Super Admin', 
      'email': 'admin@admin.com', 
      'password': 'admin123', 
      'role': 'admin'
    });
    // Akun percobaan User Biasa
    await db.insert('users', {
      'nama': 'Mahasiswa Rajin', 
      'email': 'user@gmail.com', 
      'password': 'user123', 
      'role': 'user'
    });

    // Kategori
    await db.insert('kategori', {'nama': 'HTML', 'deskripsi': 'Belajar dasar struktur website'});
    await db.insert('kategori', {'nama': 'CSS', 'deskripsi': 'Belajar styling dan layouting'});
    await db.insert('kategori', {'nama': 'JavaScript', 'deskripsi': 'Belajar interaktivitas website'});

    // Modul HTML
    await db.insert('modul', {'kategori_id': 1, 'judul': 'Pengenalan HTML', 'order_index': 1});
    await db.insert('modul', {'kategori_id': 1, 'judul': 'Struktur HTML', 'order_index': 2});

    // Konten HTML
    await db.insert('konten', {
      'modul_id': 1,
      'penjelasan_materi': 'HTML (HyperText Markup Language) adalah bahasa standar untuk membuat halaman web.',
      'cuplikan_kode': '<h1>Hello World</h1>\n<p>Ini paragraf.</p>',
      'penjelasan_kode': 'Tag h1 digunakan untuk judul utama. Tag p untuk paragraf.'
    });

    // Kuis HTML
    await db.insert('kuis', {
      'modul_id': 1,
      'pertanyaan': 'Apa kepanjangan dari HTML?',
      'opt_a': 'Hyper Text Markup Language',
      'opt_b': 'Hyperlinks and Text Markup Language',
      'opt_c': 'Home Tool Markup Language',
      'opt_d': 'Hyper Tool Multi Language',
      'jawaban': 'A'
    });
    await db.insert('kuis', {
      'modul_id': 1,
      'pertanyaan': 'Tag untuk membuat paragraf adalah?',
      'opt_a': '<pg>',
      'opt_b': '<p>',
      'opt_c': '<para>',
      'opt_d': '<text>',
      'jawaban': 'B'
    });
  }

  // ==========================================
  // FUNGSI AUTHENTICATION (LOGIN & REGISTER)
  // ==========================================

  // Fungsi untuk mengecek login
  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    // Jika data ditemukan, kembalikan baris pertama (akunnya)
    if (result.isNotEmpty) {
      return result.first;
    }
    return null; // Jika salah/tidak ditemukan
  }

  // Fungsi untuk mendaftarkan user baru (Sign Up)
  Future<int> registerUser(String nama, String email, String password) async {
    final db = await instance.database;
    return await db.insert('users', {
      'nama': nama,
      'email': email,
      'password': password,
      'role': 'user' // Setiap user yang daftar otomatis jadi 'user' biasa
    });
  }
}
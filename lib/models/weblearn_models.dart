class UserQuizResult {
  final String email;       // Email mahasiswa yang mengerjakan
  final String kategori;    // HTML, CSS, atau JS
  final String namaKuis;   // Judul paket kuisnya
  final int skor;          // Nilai (0 - 100)
  final DateTime timestamp; // Waktu pengerjaan

  UserQuizResult({
    required this.email,
    required this.kategori,
    required this.namaKuis,
    required this.skor,
    required this.timestamp,
  });

  // Konversi dari data Firestore ke Objek Dart
  factory UserQuizResult.fromMap(Map<String, dynamic> map) {
    return UserQuizResult(
      email: map['email'] ?? '',
      kategori: map['kategori'] ?? '',
      namaKuis: map['nama_kuis'] ?? '',
      skor: map['skor'] ?? 0,
      timestamp: map['timestamp'] != null 
          ? (map['timestamp'] as dynamic).toDate() 
          : DateTime.now(),
    );
  }

  // Konversi dari Objek Dart ke Map sebelum diunggah ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'kategori': kategori,
      'nama_kuis': namaKuis,
      'skor': skor,
      'timestamp': timestamp,
    };
  }
}
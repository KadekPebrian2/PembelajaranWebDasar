class Kategori {
  final int? id;
  final String nama;
  final String deskripsi;

  Kategori({this.id, required this.nama, required this.deskripsi});

  factory Kategori.fromMap(Map<String, dynamic> json) => Kategori(
        id: json['id'],
        nama: json['nama'],
        deskripsi: json['deskripsi'],
      );
}

class Modul {
  final int? id;
  final int kategoriId;
  final String judul;
  final int orderIndex;

  Modul({this.id, required this.kategoriId, required this.judul, required this.orderIndex});

  factory Modul.fromMap(Map<String, dynamic> json) => Modul(
        id: json['id'],
        kategoriId: json['kategori_id'],
        judul: json['judul'],
        orderIndex: json['order_index'],
      );
}

class Konten {
  final int? id;
  final int modulId;
  final String penjelasanMateri;
  final String cuplikanKode;
  final String penjelasanKode;

  Konten({this.id, required this.modulId, required this.penjelasanMateri, required this.cuplikanKode, required this.penjelasanKode});

  factory Konten.fromMap(Map<String, dynamic> json) => Konten(
        id: json['id'],
        modulId: json['modul_id'],
        penjelasanMateri: json['penjelasan_materi'],
        cuplikanKode: json['cuplikan_kode'],
        penjelasanKode: json['penjelasan_kode'],
      );
}

class Kuis {
  final int? id;
  final int modulId;
  final String pertanyaan;
  final String optA, optB, optC, optD, jawaban;

  Kuis({this.id, required this.modulId, required this.pertanyaan, required this.optA, required this.optB, required this.optC, required this.optD, required this.jawaban});

  factory Kuis.fromMap(Map<String, dynamic> json) => Kuis(
        id: json['id'],
        modulId: json['modul_id'],
        pertanyaan: json['pertanyaan'],
        optA: json['opt_a'],
        optB: json['opt_b'],
        optC: json['opt_c'],
        optD: json['opt_d'],
        jawaban: json['jawaban'],
      );
}
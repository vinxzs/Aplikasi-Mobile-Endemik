class Endemik {
  final String id;
  final String nama;
  final String namaLatin;
  final String deskripsi;
  final String asal;
  final String foto;
  final String status;
  final String isFavorit;

  Endemik({
    required this.id,
    required this.nama,
    required this.namaLatin,
    required this.deskripsi,
    required this.asal,
    required this.foto,
    required this.status,
    required this.isFavorit,
  });

  // Konversi dari Map ke Object (untuk database)
  factory Endemik.fromMap(Map<String, dynamic> map) {
    return Endemik(
      id: map['id'],
      nama: map['nama'],
      namaLatin: map['nama_latin'],
      deskripsi: map['deskripsi'],
      asal: map['asal'],
      foto: map['foto'],
      status: map['status'],
      isFavorit: map['is_favorit'],
    );
  }

  // Konversi dari JSON ke Object (untuk API)
  factory Endemik.fromJson(Map<String, dynamic> json) {
    return Endemik(
      id: json['id'],
      nama: json['nama'],
      namaLatin: json['nama_latin'],
      deskripsi: json['deskripsi'],
      asal: json['asal'],
      foto: json['foto'],
      status: json['status'],
      isFavorit: json['is_favorit'] ?? 'false',
    );
  }

  // Konversi Object ke Map (untuk menyimpan ke database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'nama_latin': namaLatin,
      'deskripsi': deskripsi,
      'asal': asal,
      'foto': foto,
      'status': status,
      'is_favorit': isFavorit,
    };
  }
}
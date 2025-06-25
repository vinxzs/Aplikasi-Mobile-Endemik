class Endemik {
  String id;
  String nama;
  String namaLatin;
  String deskripsi;
  String asal;
  String foto;
  String status;
  String isFavorit; // Menggunakan String ("true" / "false") sesuai DB

  Endemik({
    required this.id,
    required this.nama,
    required this.namaLatin,
    required this.deskripsi,
    required this.asal,
    required this.foto,
    this.status = '', // Memberikan nilai default kosong jika tidak ada dari JSON/Map
    this.isFavorit = "false", // Default false
  });

  // Convert Endemik object to Map (for database insertion)
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

  // Convert Map to Endemik object (for database retrieval)
  factory Endemik.fromMap(Map<String, dynamic> map) {
    return Endemik(
      id: map['id'] as String,
      nama: map['nama'] as String,
      namaLatin: map['nama_latin'] as String,
      deskripsi: map['deskripsi'] as String,
      asal: map['asal'] as String,
      foto: map['foto'] as String,
      status: map['status'] as String? ?? '', // Handle null by providing default
      isFavorit: map['is_favorit'] as String? ?? "false", // Handle null by providing default
    );
  }

  // Convert JSON to Endemik object (for API fetching)
  factory Endemik.fromJson(Map<String, dynamic> json) {
    return Endemik(
      id: json['id'] as String,
      nama: json['nama'] as String,
      namaLatin: json['nama_latin'] as String,
      deskripsi: json['deskripsi'] as String,
      asal: json['asal'] as String,
      foto: json['foto'] as String,
      status: json['status'] as String? ?? '',
      isFavorit: json['is_favorit'] as String? ?? "false",
    );
  }
}
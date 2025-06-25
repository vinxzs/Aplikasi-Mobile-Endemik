// lib/service/endemik_service.dart

import 'package:dio/dio.dart';
import '../model/endemik.dart';
import '../helper/database_helper.dart';

class EndemikService {
  final Dio _dio = Dio();

  Future<bool> isDataAvailable() async {
    final dbHelper = DatabaseHelper();
    final int count = await dbHelper.count();
    return count > 0;
  }

  Future<List<Endemik>> getData() async {
    final dbHelper = DatabaseHelper();

    try {
      bool dataExists = await isDataAvailable();
      if (dataExists) {
        print("Data sudah ada di database, tidak perlu mengambil dari API.");
        final List<Endemik> oldData = await dbHelper.getAll();
        return oldData;
      }

      final response = await _dio.get('https://hendroprwk08.github.io/data_endemik/endemik.json');
      final List<dynamic> data = response.data;

      for (var json in data) {
        Endemik model = Endemik(
          id: json["id"],
          nama: json["nama"],
          namaLatin: json["nama_latin"],
          deskripsi: json["deskripsi"],
          asal: json["asal"],
          foto: json["foto"],
          status: json["status"],
          isFavorit: json["is_favorit"] ?? "false", // Pastikan ini string
        );

        await dbHelper.insert(model);
      }

      return data.map((json) => Endemik.fromJson(json)).toList();
    } catch (e) {
      print(e);
      // Jika ada error (misal: tidak ada koneksi internet saat pertama kali),
      // coba ambil dari database lokal (jika ada) atau kembalikan list kosong.
      final List<Endemik> localData = await dbHelper.getAll();
      if (localData.isNotEmpty) {
        print("Error fetching from API, loading local data.");
        return localData;
      }
      return [];
    }
  }

  Future<List<Endemik>> getFavoritData() async {
    final dbHelper = DatabaseHelper();
    return await dbHelper.getFavoritAll();
  }

  // Tambahkan method untuk setFavorit
  Future<void> setFavorit(String id, String isFavorit) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.setFavorit(id, isFavorit);
  }

  // Tambahkan method untuk deleteFavoritAll
  Future<void> deleteFavoritAll() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteFavoritAll();
  }
}
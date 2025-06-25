// lib/screens/detail_screen.dart

import 'package:flutter/material.dart';
import '../model/endemik.dart';
import '../service/endemik_service.dart';
import 'package:photo_view/photo_view.dart';

class DetailScreen extends StatefulWidget {
  final Endemik endemik;

  const DetailScreen({super.key, required this.endemik});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool _isFavorit;
  final EndemikService _endemikService = EndemikService();

  @override
  void initState() {
    super.initState();
    _isFavorit = widget.endemik.isFavorit == "true";
  }

  Future<void> _toggleFavorit() async {
    final newFavoritStatus = !_isFavorit;
    await _endemikService.setFavorit(widget.endemik.id, newFavoritStatus.toString());

    setState(() {
      _isFavorit = newFavoritStatus;
      widget.endemik.isFavorit = newFavoritStatus.toString();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(newFavoritStatus
            ? 'Berhasil ditambahkan ke favorit!'
            : 'Berhasil dihapus dari favorit!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.endemik.nama),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorit ? Icons.favorite : Icons.favorite_border,
              color: _isFavorit ? Colors.red : Colors.white,
            ),
            onPressed: _toggleFavorit,
            tooltip: _isFavorit ? 'Hapus dari favorit' : 'Tambahkan ke favorit',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                      appBar: AppBar(backgroundColor: Colors.black),
                      body: PhotoView(
                        imageProvider: NetworkImage(widget.endemik.foto),
                        heroAttributes: PhotoViewHeroAttributes(tag: widget.endemik.id),
                        backgroundDecoration: const BoxDecoration(color: Colors.black),
                      ),
                    ),
                  ),
                );
              },
              child: Hero(
                tag: widget.endemik.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.endemik.foto,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.broken_image, size: 100));
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.endemik.nama,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.endemik.namaLatin,
              style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            const SizedBox(height: 15),
            const Text(
              'Keterangan:', // Label "Keterangan"
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              widget.endemik.deskripsi,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.justify, // Teks rata kanan kiri
            ),
            const SizedBox(height: 15),
            Text(
              'Asal: ${widget.endemik.asal}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            // Tampilan "Status Konservasi" sebagai badge/chip
            Chip(
              label: Text(
                'Status Konservasi: ${widget.endemik.status}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.green.shade600, // Warna hijau agak gelap
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Membuat chip lebih kompak
            ),
          ],
        ),
      ),
    );
  }
}
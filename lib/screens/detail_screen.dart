import 'package:flutter/material.dart';
import '../model/endemik.dart';
import '../helper/database_helper.dart';

class DetailScreen extends StatefulWidget {
  final Endemik endemik;

  const DetailScreen({super.key, required this.endemik});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.endemik.isFavorit == 'true';
  }

  void _toggleFavorite() async {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    await _dbHelper.setFavorit(widget.endemik.id, _isFavorite ? 'true' : 'false');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.endemik.nama),
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: _isFavorite ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                widget.endemik.foto,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error);
                },
              ),
              const SizedBox(height: 16),
              Text(
                widget.endemik.nama,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Nama Latin: ${widget.endemik.namaLatin}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Asal: ${widget.endemik.asal}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Status Konservasi: ${widget.endemik.status}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text('Deskripsi: ${widget.endemik.deskripsi}', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
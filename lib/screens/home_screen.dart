// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../model/endemik.dart';
import '../service/endemik_service.dart';
import './detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final EndemikService _endemikService = EndemikService();

  final GlobalKey<_BerandaTabState> _berandaTabKey = GlobalKey();
  final GlobalKey<_FavoritTabState> _favoritTabKey = GlobalKey();

  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      _BerandaTab(key: _berandaTabKey, endemikService: _endemikService),
      _FavoritTab(key: _favoritTabKey, endemikService: _endemikService),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Memuat ulang data setiap kali tab diubah
    if (index == 1) { // Jika pindah ke tab favorit
      _favoritTabKey.currentState?.refreshData();
    } else { // Jika pindah ke tab beranda
      _berandaTabKey.currentState?.refreshData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EndemikDB'), //
        // centerTitle dan styles sudah diatur di main.dart
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // Colors dan styles sudah diatur di main.dart
      ),
    );
  }
}

// ===========================================================================
// Widget untuk Tab "Beranda" (Daftar Semua Burung)
// ===========================================================================
class _BerandaTab extends StatefulWidget {
  final EndemikService endemikService;
  const _BerandaTab({super.key, required this.endemikService});

  @override
  State<_BerandaTab> createState() => _BerandaTabState();
}

class _BerandaTabState extends State<_BerandaTab> {
  late Future<List<Endemik>> _allEndemikData;

  @override
  void initState() {
    super.initState();
    _loadAllEndemikData();
  }

  void _loadAllEndemikData() {
    setState(() {
      _allEndemikData = widget.endemikService.getData();
    });
  }

  void refreshData() {
    _loadAllEndemikData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Endemik>>(
      future: _allEndemikData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada data endemik.'));
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8, // Perbandingan lebar/tinggi card
              crossAxisSpacing: 10, // Spasi horizontal antar card
              mainAxisSpacing: 10,  // Spasi vertikal antar card
            ),
            padding: const EdgeInsets.all(10), // Padding di sekitar grid
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final endemik = snapshot.data![index];
              return Card(
                // Elevation dan shape sudah diatur di main.dart CardTheme
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(endemik: endemik),
                      ),
                    );
                    // Refresh data di kedua tab setelah kembali dari DetailScreen
                    // Agar perubahan favorit di detail screen langsung terlihat
                    (context.findAncestorStateOfType<_HomeScreenState>())
                        ?._berandaTabKey.currentState?.refreshData();
                    (context.findAncestorStateOfType<_HomeScreenState>())
                        ?._favoritTabKey.currentState?.refreshData();
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child:
                        Image.network(
                          endemik.foto,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey));
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                                strokeWidth: 2,
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          endemik.nama,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

// ===========================================================================
// Widget untuk Tab "Favorit"
// ===========================================================================
class _FavoritTab extends StatefulWidget {
  final EndemikService endemikService;
  const _FavoritTab({super.key, required this.endemikService});

  @override
  State<_FavoritTab> createState() => _FavoritTabState();
}

class _FavoritTabState extends State<_FavoritTab> {
  late Future<List<Endemik>> _favoriteEndemikData;

  @override
  void initState() {
    super.initState();
    _loadFavoriteData();
  }

  void _loadFavoriteData() {
    setState(() {
      _favoriteEndemikData = widget.endemikService.getFavoritData();
    });
  }

  void refreshData() {
    _loadFavoriteData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<Endemik>>(
            future: _favoriteEndemikData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'Kosong', // Teks "Kosong" saat tidak ada favorit
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                );
              } else {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  padding: const EdgeInsets.all(10),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final endemik = snapshot.data![index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(endemik: endemik),
                            ),
                          );
                          // Refresh data di kedua tab setelah kembali dari DetailScreen
                          (context.findAncestorStateOfType<_HomeScreenState>())
                              ?._berandaTabKey.currentState?.refreshData();
                          (context.findAncestorStateOfType<_HomeScreenState>())
                              ?._favoritTabKey.currentState?.refreshData();
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.network(
                                endemik.foto,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey));
                                },
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                          : null,
                                      strokeWidth: 2,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                endemik.nama,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        // Tombol "Hapus" untuk menghapus semua favorit
        Padding(
          padding: const EdgeInsets.all(10.0), // Padding di sekitar tombol
          child: SizedBox(
            width: double.infinity, // Lebar penuh
            child: ElevatedButton.icon(
              onPressed: () async {
                bool? confirm = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext dialogContext) {
                    return AlertDialog(
                      title: const Text('Konfirmasi'),
                      content: const Text('Anda yakin ingin menghapus semua favorit?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(false),
                          child: const Text('Batal'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(true),
                          child: const Text('Hapus'),
                        ),
                      ],
                    );
                  },
                );

                if (confirm == true) {
                  await widget.endemikService.deleteFavoritAll();
                  _loadFavoriteData(); // Refresh daftar favorit
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua favorit telah dihapus.')),
                  );
                }
              },
              icon: const Icon(Icons.delete_forever), // Ikon sampah
              label: const Text('Hapus'), // Teks "Hapus"
              // Style diambil dari Theme.of(context).elevatedButtonTheme.style
            ),
          ),
        ),
      ],
    );
  }
}
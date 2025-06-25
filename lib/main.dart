// lib/main.dart

import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Endemik App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tema warna keseluruhan aplikasi
        primaryColor: const Color(0xFF003049), // Warna biru gelap/teal untuk AppBar
        scaffoldBackgroundColor: Colors.white, // Background scaffold putih
        canvasColor: Colors.white, // Warna latar belakang default untuk beberapa widget

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF003049), // Warna AppBar
          foregroundColor: Colors.white, // Warna teks ikon di AppBar
          elevation: 0, // Tidak ada shadow
          centerTitle: true, // Judul di tengah
          titleTextStyle: TextStyle( // Gaya teks judul
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF003049), // Warna ikon/label aktif (biru gelap)
          unselectedItemColor: Colors.grey, // Warna ikon/label tidak aktif (abu-abu)
          backgroundColor: Colors.white, // Background BNB putih
          elevation: 8, // Sedikit shadow
          type: BottomNavigationBarType.fixed, // Pastikan ikon tidak bergeser
          selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 12),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFDD835), // Warna kuning untuk tombol Hapus
            foregroundColor: Colors.black, // Teks hitam untuk tombol Hapus
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Sudut membulat
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding standar
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        cardTheme: CardTheme(
          elevation: 4, // Shadow untuk card
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Sudut membulat
          margin: const EdgeInsets.all(0), // Margin akan diatur di GridView builder
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
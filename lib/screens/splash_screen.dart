// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _loadingMessage = 'Splash Screen';

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // Delay awal untuk logo dan splash screen text
    await Future.delayed(const Duration(milliseconds: 3000)); // 3 detik

    // Ganti teks loading
    if (mounted) {
      setState(() {
        _loadingMessage = 'Splash Screen';
      });
    }

    // Delay tambahan sebelum navigasi ke home
    await Future.delayed(const Duration(milliseconds: 2000)); // 2 detik

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background putih sesuai video
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menggunakan Icon Flutter sebagai placeholder logo
            Icon(
              Icons.pets, // Anda bisa ganti dengan ikon lain yang relevan
              size: 150, // Sesuaikan ukuran
              color: const Color(0xFF9C27B0), // Warna ungu seperti teks splash screen
            ),
            const SizedBox(height: 20),
            const Text(
              'Splash Screen', // Teks "Splash Screen"
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF9C27B0), // Warna ungu seperti di video
              ),
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(
              color: Color(0xFF003049), // Warna loading indicator
              strokeWidth: 3,
            ),
            const SizedBox(height: 30),
            Text(
              _loadingMessage, // Teks pesan loading yang berubah
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF9C27B0), // Warna ungu seperti di video
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
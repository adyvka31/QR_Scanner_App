import 'package:flutter/material.dart';
import 'package:qr_scanner_app/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startApp();
  }

  void _startApp() async {
    // Beri jeda sedikit (opsional, untuk estetika splash screen)
    await Future.delayed(const Duration(seconds: 2));

    // Pindah ke halaman berikutnya
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code, size: 100, color: Color(0xff9E3B3B)),
            SizedBox(height: 4),
            Text(
              "QR SCANNER APP",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xff9E3B3B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

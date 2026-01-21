import 'package:flutter/material.dart';
import 'package:qr_scanner_app/services/api_service.dart';

class AddGuestScreen extends StatefulWidget {
  const AddGuestScreen({super.key});

  @override
  State<AddGuestScreen> createState() => _AddGuestScreenState();
}

class _AddGuestScreenState extends State<AddGuestScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk mengambil teks input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = false;

  // Fungsi saat tombol Save ditekan
  Future<void> _submitGuest() async {
    // 1. Cek Validasi (Apakah form sudah diisi dengan benar?)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService().addTicket(_nameController.text);

      // Simulasi delay request server
      await Future.delayed(Duration(seconds: 2));

      if (!mounted) return;

      // Tampilkan notifikasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Guest berhasil ditambahkan!'),
          backgroundColor: Colors.green,
        ),
      );

      // Kembali ke halaman sebelumnya dan kirim sinyal 'true' agar home refresh
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color themeColor = Color(0xff9E3B3B);

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: themeColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.red, width: 1),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 13),
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white70, // Warna Background
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ), // Membuat sudut melengkung
            border: Border.all(
              color: Color(0xff9E3B3B), // Warna Garis Tepi (Border)
              width: 0.2, // Ketebalan Garis
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // --- Tombol Back (Kiri) ---
              Positioned(
                left: -15,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.arrow_back_ios_new, // Icon panah yang lebih modern
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Fungsi kembali
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 90),
                child: Text(
                  "Create New Guest",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16), // Margin kiri kanan saja
        width: double.infinity,
        height: double.infinity, // Agar container mengisi layar ke bawah
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          border: Border.all(color: themeColor, width: 0.2),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // INPUT NAMA
                Text(
                  "Full Name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: inputDecoration.copyWith(
                    hintText: "Ex: John Doe",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Nama wajib diisi';
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // INPUT EMAIL
                Text(
                  "Email Address",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration.copyWith(
                    hintText: "Ex: john@email.com",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Email wajib diisi';
                    if (!value.contains('@')) return 'Email tidak valid';
                    return null;
                  },
                ),
                SizedBox(height: 20),

                // INPUT PHONE (Opsional)
                Text(
                  "Phone Number",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: inputDecoration.copyWith(
                    hintText: "Ex: 08123456789",
                  ),
                ),
                SizedBox(height: 40),

                // TOMBOL SAVE
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitGuest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            "Generate QR Code",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qr_scanner_app/models/ticket.dart';
import 'package:qr_scanner_app/services/api_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scanner_app/views/add_guest_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _api = ApiService();
  List<Ticket> _tickets = [];
  bool _isLoading = true;

  // Controller untuk scanner agar bisa dipause/resume
  MobileScannerController cameraController = MobileScannerController();
  bool _isProcessingScan = false;

  @override
  void initState() {
    super.initState();
    _refreshTickets();
  }

  Future<void> _refreshTickets() async {
    if (_tickets.isEmpty) setState(() => _isLoading = true);
    try {
      final data = await _api.getTickets();
      setState(() => _tickets = data);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal memuat tiket: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Menambahkan fungsi delete yang sebelumnya hilang
  Future<void> _deleteTicket(String id) async {
    try {
      // await _api.deleteTicket(id); // Uncomment jika API sudah siap
      setState(() {
        _tickets.removeWhere((ticket) => ticket.id == id);
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tiket berhasil dihapus')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
    }
  }

  // Fungsi untuk menangani hasil scan di Tab 2
  Future<void> _handleScan(String code) async {
    if (_isProcessingScan) return; // Mencegah scan berulang-ulang secepat kilat

    setState(() => _isProcessingScan = true);

    // Tampilkan Dialog Loading atau Proses API
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      // 1. Panggil API Redeem di sini (sesuai diskusi sebelumnya)
      // await _api.redeemTicket(code);

      // Simulasi delay API
      await Future.delayed(Duration(seconds: 1));

      Navigator.pop(context); // Tutup loading dialog

      // 2. Tampilkan Sukses
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Berhasil Redeem!"),
          content: Text("Kode Tiket: $code"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _refreshTickets(); // Refresh list tamu
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Tutup loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal Redeem: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      // Beri jeda sedikit sebelum bisa scan lagi
      await Future.delayed(Duration(seconds: 2));
      setState(() => _isProcessingScan = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color themeColor = Color(0xff9E3B3B);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar( 
          title: Container(
            padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'QR Scanner',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black, // Pastikan warna teks kontras
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(builder: (_) => AddGuestScreen()),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_add,
                        color: Color(0xff9E3B3B),
                        size: 20,
                      ),
                      SizedBox(width: 6), // Jarak ikon dan teks
                      Text(
                        "Add Guest",
                        style: TextStyle(
                          color: Color(0xff9E3B3B),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Container(
          // Margin agar terpisah dari AppBar dan pinggir layar
          margin: EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            border: Border.all(color: themeColor, width: 0.2),
          ),
          child: Column(
            children: [
              // 1. TAB BAR (Sekarang ada di dalam Container Body)
              Container(
                decoration: BoxDecoration(
                  // Opsional: Memberi garis batas bawah antara Tab dan Isi
                  border: Border(
                    bottom: BorderSide(color: themeColor, width: 0.2),
                  ),
                ),
                child: TabBar(
                  labelColor: themeColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: themeColor,
                  indicatorSize:
                      TabBarIndicatorSize.tab, // Garis indikator selebar tab
                  tabs: [
                    Tab(icon: Icon(Icons.list), text: "Guest List"),
                    Tab(
                      icon: Icon(Icons.qr_code_scanner),
                      text: "Scan & Redeem",
                    ),
                  ],
                ),
              ),

              // 2. ISI TAB (TabBarView)
              // Wajib pakai Expanded agar mengisi sisa ruang di bawah TabBar
              Expanded(
                child: TabBarView(
                  children: [
                    // === TAB 1: Guest List ===
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : RefreshIndicator(
                            onRefresh: _refreshTickets,
                            child: _tickets.isEmpty
                                ? Center(
                                    child: Text("Belum ada tiket yang discan"),
                                  )
                                : ListView.builder(
                                    padding: EdgeInsets.only(
                                      top: 20,
                                      left: 20,
                                      right: 20,
                                    ), // Padding dalam list
                                    itemCount: _tickets.length,
                                    itemBuilder: (context, index) {
                                      final ticket = _tickets[index];
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Color(0xff9E3B3B),
                                            width: 0.2,
                                          ),
                                        ),
                                        child: ListTile(
                                          title: Text(ticket.name),
                                          subtitle: Text(ticket.status),
                                          trailing: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () =>
                                                _deleteTicket(ticket.id),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),

                    // === TAB 2: Scanner ===
                    // ClipRRect agar kamera tidak menembus sudut melengkung container
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Stack(
                        children: [
                          MobileScanner(
                            controller: cameraController,
                            onDetect: (capture) {
                              final List<Barcode> barcodes = capture.barcodes;
                              for (final barcode in barcodes) {
                                if (barcode.rawValue != null) {
                                  _handleScan(barcode.rawValue!);
                                }
                              }
                            },
                          ),
                          Center(
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: themeColor, width: 3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

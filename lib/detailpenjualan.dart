import 'package:flutter/material.dart';
import 'package:ukk_2025/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailPenjualanTab extends StatefulWidget {
  const DetailPenjualanTab({super.key});

  @override
  State<DetailPenjualanTab> createState() => _DetailPenjualanTabState();
}

class _DetailPenjualanTabState extends State<DetailPenjualanTab> {
  int jumlahPesanan = 0;
  int totalHarga = 0;
  int stokAwal = 0;
  int stokSisa = 0;
  int? selectedpelangganid;
  List<Map<String, dynamic>> pelangganList = [];

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future<void> fetchPelanggan() async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.from('pelanggan').select('pelangganid, namapelanggan');
      if (response.isNotEmpty) {
        setState(() {
          pelangganList = List<Map<String, dynamic>>.from(response);
          selectedpelangganid = pelangganList.first['pelangganid'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data pelanggan: $e')),
      );
    }
  }

  void updateJumlahPesanan(int harga, int delta) {
    setState(() {
      if (delta > 0 && jumlahPesanan >= stokAwal) return;
      jumlahPesanan += delta;
      if (jumlahPesanan < 0) jumlahPesanan = 0;
      stokSisa = stokAwal - jumlahPesanan;
      totalHarga = jumlahPesanan * harga;
    });
  }

  Future<void> simpan() async {
    final supabase = Supabase.instance.client;

    if (selectedpelangganid == null || jumlahPesanan <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua wajib diisi')),
      );
      return;
    }

    try {
      final penjualan = await supabase.from('penjualan').insert({
        'TotalHarga': totalHarga,
        'PelangganID': selectedpelangganid,
      }).select().single();

      if (penjualan.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesanan berhasil disimpan')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Penjualan'),
        backgroundColor: Colors.blue.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<int>(
                  value: selectedpelangganid,
                  items: pelangganList.map((pelanggan) {
                    return DropdownMenuItem<int>(
                      value: pelanggan['pelangganid'],
                      child: Text(pelanggan['namapelanggan']),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedpelangganid = value;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Pilih Pelanggan',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Tutup', style: TextStyle(fontSize: 20)),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: jumlahPesanan > 0 ? simpan : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade300,
                      ),
                      child: Text('Pesan ($totalHarga)', style: const TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
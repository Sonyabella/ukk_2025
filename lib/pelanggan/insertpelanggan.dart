import 'package:flutter/material.dart';
import 'package:ukk_2025/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPelanggan extends StatefulWidget {
  const AddPelanggan({super.key});

  @override
  State<AddPelanggan> createState() => _AddPelangganState();
}

class _AddPelangganState extends State<AddPelanggan> {
  final _namapelanggan= TextEditingController();
  final _alamat= TextEditingController();
  final _nomortelepon = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Function to insert pelanggan data
  Future<void> insertPelanggan() async {
    if (_formKey.currentState!.validate()) {
      final String namapelanggan = _namapelanggan.text;
      final String alamat = _alamat.text;
      final String nomortelepon = _nomortelepon.text;

      try {
        // Proses insert ke tabel pelanggan
        await Supabase.instance.client.from('pelanggan').insert(
          {
            'namapelanggan': namapelanggan,
            'alamat': alamat,
            'nomortelepon': nomortelepon,
          },
        );

        // Tampilkan notifikasi keberhasilan
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pelanggan berhasil ditambahkan!'),
          ),
        );

        // Navigasi kembali ke halaman utama
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>HomePage()),
        );
      } catch (e) {
        // Tangani kesalahan
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Pelanggan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namapelanggan,
                decoration: const InputDecoration(
                  labelText: 'Nama Pelanggan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _alamat,
                decoration: const InputDecoration(
                  labelText: 'alamat',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomortelepon,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor telepon tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: insertPelanggan,
                child: const Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
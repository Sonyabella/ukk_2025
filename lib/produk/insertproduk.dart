import 'package:flutter/material.dart';
import 'package:ukk_2025/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddProduk extends StatefulWidget {
  const AddProduk({super.key});

  @override   
  State<AddProduk> createState() => _AddProdukState();
}

class _AddProdukState extends State<AddProduk> {
  final _nmprd = TextEditingController();
  final _harga = TextEditingController();
  final _stok = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> tambahProduk() async {
    if (_formKey.currentState!.validate()) {
      final namaproduk = _nmprd.text;
      final harga = double.tryParse(_harga.text) ?? 0;
      final stok = int.tryParse(_stok.text) ?? 0;

      try {
        await Supabase.instance.client.from('produk').insert(
          {
            'namaproduk': namaproduk,
            'harga': harga,
            'stok': stok,
          },
        );
        if (mounted) {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        }
      } catch (e) {
        print('Error inserting produk: $e');
      }
    }
  }

  @override   
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Produk'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nmprd,
                decoration: const InputDecoration(
                  labelText: 'Nama Produk',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _harga,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _stok,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stok',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Stok tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: tambahProduk, 
                child: const Text('Tambah'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ukk_2025/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

 class PenjualanUpdate extends StatefulWidget {
  final int pelangganid;

  const PenjualanUpdate({super.key, required this.pelangganid});

  @override  
  State<PenjualanUpdate> createState() => _PenjualanUpdateState();
 }

 class _PenjualanUpdateState extends State<PenjualanUpdate> {
  final _tglController = TextEditingController();
  final _hrgController = TextEditingController();
  final _pelangganController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override 
  void initState() {
    super.initState();
    _loadingPenjualanData();
  }  

  Future<void> _loadingPenjualanData() async {
    try {
      final data = await Supabase.instance.client
      .from('penjualan')
      .select()
      .eq('Pelangganid', widget.pelangganid)
      .single();

      setState(() {
        _tglController.text = data['TanggalPenjualan'] ?? '';
        _hrgController.text = data['Harga'] ?.toString()??'';
        _pelangganController.text = data['Pelanggan'] ?? '';
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $error')),
      );
     }
   }

   Future<void> _updatePenjualan() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Supabase.instance.client.from('penjualan').update({
          'TanggalPenjualan': _tglController.text,
          'Harga': double.tryParse(_hrgController.text) ?? 0,
          'Pelangganid': _pelangganController.text,
        }).eq('Pelangganid', widget.pelangganid);

        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => HomePage()),
          (route) => false,
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating data: $error')),
        );
      }
    }
   }

   @override   
   void dispose() {
    _tglController.dispose();
    _hrgController.dispose();
    _pelangganController.dispose();
    super.dispose();
   }

   @override   
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Penjualan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _tglController,
              decoration: InputDecoration(
                labelText: 'Tanggal Penjualan',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Tanggal Penjualan Tidak boleh kosong';
                 }
                 return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _hrgController,
              decoration: InputDecoration(
                labelText: 'Harga',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Harga tidak boleh kosong';
                }
                if (double.tryParse(value) == null) {
                  return 'Harga harus berupa angka';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _pelangganController,
              decoration: InputDecoration(
                labelText: 'Pelanggan ID',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pelanggan ID tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updatePenjualan, 
              child: Text('Update'),
              ),
             ],
            ),
           ),
          );
         }
        }
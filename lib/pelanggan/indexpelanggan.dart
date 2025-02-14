import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class PelangganTab extends StatefulWidget {
  @override   
  _PelangganTabState createState() => _PelangganTabState();
}

class PelangganTab extends State<PelangganTab> {
  List<Map<String, dynamic>> pelanggan = [];
  bool isLoading = true;

  @override     
  void initState() {
    super.initState();
    fetchPelanggan();
  }

  Future <void> fetchPelanggan() async {
    setState(() {
      isLoading = true;

    });
    try {
      final response = await Supabase.instance.client.from('pelanggan').select();
      
      
    } catch (e) {
      
    }
  }
}

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProdukTab extends StatefulWidget {
  @override   
  _ProdukState createState() => _ProdukState();
}

class _ProdukState extends State<ProdukTab> {
  List<Map<String, dynamic>> produk =[];
  bool isloading = true;

  @override   
  void initState() {
    super.initState();
    fetchProduk();
  }

  Future<void> fetchProduk() async {
    setState(() {
      isloading = true;
    });
    try {
      final response = await Supabase.instance.client.from('produk').select();
      setState(() {
        produk = List<Map<String, dynamic>>.from(response);
        isloading = false;
      });
    } catch (e) {
      print('Error fetching produk: $e');
      setState(() {
        isloading = false;
      });
    }
  }
  Future<void> deleteProduk(int id) async {
    try {
      await Supabase.instance.client.from('produk').delete().eq('ProdukID', id);
      fetchProduk();
    } catch (e) {
      print('Error deleting Produk: $e');
    }
  }

  @override   
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? Center(
              child: LoadingAnimationWidget.twoRotatingArc(
                color: Colors.grey, size: 30),
          )
          : produk.isEmpty
          ? Center(
            child: Text(
              'Tidak ada produk',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
          )
          : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 4 / 4,
              ), 
              padding: EdgeInsets.all(8),
              itemCount: produk.length,
               itemBuilder:(context, index) {
                 final pelanggan =produk[index];
                 return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pelanggan['NamProduk'] ?? 'Produk tidak tersedia',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Text(
                          pelanggan['Harga']?.toString() ??
                          'Harga tidak tersedia',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Text(
                          pelanggan['Stok']?.toString() ??
                          'Stok tidak tersedia',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                 );
               },)
    );
  }
  
}
import 'package:flutter/material.dart';
import 'package:ukk_2025/penjualan/insertpenjualan.dart';
import 'package:ukk_2025/penjualan/transaksi.dart';
import 'package:ukk_2025/penjualan/updatepenjualan.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class PenjualanTab extends StatefulWidget {
  @override  
  _PenjualanTabState createState() => _PenjualanTabState();
}

class _PenjualanTabState extends State<PenjualanTab> {
  List<Map<String, dynamic>> penjualan = [];
  bool isloading = true;

  @override  
  void initState() {
    super.initState();
    fetchPenjualan();
  }
  Future<void> fetchPenjualan() async {
    setState(() {
      isloading = true;
    });
    try {
      final response = await Supabase.instance.client.from('penjualan').select();
      setState(() {
        penjualan = List<Map<String, dynamic>>.from(response);
        isloading = false;
      });
    } catch (e) {
      print('Error fetching penjualan: $e');
      setState(() {
        isloading = false;
      });
    }
  }

  Future<void> deleteBarang(int id) async {
    try {
      await Supabase.instance.client.from('penjualan').delete().eq('penjualanid', id);
      fetchPenjualan();
    } catch (e) {
      print('Error deleting barang: $e');
    }
  }

  @override  
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
      ?Center(
        child: Text(
          'Tidak ada penjualan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          )
          : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              crossAxisSpacing: 12,
              ),
              padding: EdgeInsets.all(8),
              itemCount: penjualan.length,
              itemBuilder:(context, index) {
                final jual = penjualan[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                    child: SizedBox(
                      height: 150,
                      width: 20,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              jual['tanggalpenjualan'] ?? 'Tanggal tidak tersedia',
                              style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Pelanggan ID: ${jual['pelangganid'] ?? 'Tidak tersedia'}',
                              style: TextStyle(
                                fontStyle: FontStyle.italic, fontSize: 16, color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Pelanggan ID: ${jual['pelangganid'] ?? 'Tidak tersedia'}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    final penjualanid = jual['penjualanid'] ?? 0;
                                    if(penjualanid !=0) {
                                      Navigator.push(
                                        context,
                                         MaterialPageRoute(
                                          builder: (context) => PenjualanUpdate(pelangganid: penjualanid),
                                          ),
                                          );
                                    } else {
                                      print('ID pelanggan tidak valid');
                                    }
                                  },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () {
                                      showDialog(
                                        context: context, 
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Hapus Pelanggan'),
                                            content: const Text('Apakah anda yakin ingin menghapus pelanggan ini?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(context),
                                                 child: const Text('Batal'),
                                                 ),
                                                 TextButton(
                                                  onPressed: () {
                                                    deleteBarang(jual['penjualanid']);
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Hapus'),
                                                  ),
                                                 ],
                                                );
                                               },
                                              );
                                             },
                                            ),
                                           ],
                                          ),
                                         ],
                                        ),
                                       ),
                                      ), 
                                     );
                                    },
                                   ),
                                   floatingActionButton: FloatingActionButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HargaProdukAdmin()));
                                    },
                                    backgroundColor: Colors.amber,
                                    child: Icon(Icons.add),
                                    ),
                                   );
                                  }
                                  }
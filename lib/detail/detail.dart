import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailTab extends StatefulWidget {
  @override
  State<DetailTab> createState() => _DetailTabState();
}

class _DetailTabState extends State<DetailTab> {
  List<Map<String, dynamic>> detailList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> deleteDetail(int detailid) async {
    try {
      await Supabase.instance.client
          .from('detailpenjualan')
          .delete()
          .eq('detailid', detailid);
      fetchDetail();
    } catch (e) {
      print('Error deleting detail: $e');
    }
  }

  Future<void> fetchDetail() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await Supabase.instance.client
          .from('detailpenjualan')
          .select('*, penjualan(*, pelanggan(*)), produk(*)');
      setState(() {
        detailList = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      print('Error fetching detail: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : detailList.isEmpty
              ? Center(
                  child: Text(
                    'Tidak ada detail',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: detailList.length,
                  itemBuilder: (context, index) {
                    final dtl = detailList[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama Pelanggan: ${dtl['penjualan']['pelanggan']['namapelanggan'] ?? 'Tidak tersedia'}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Nama Produk: ${dtl['produk']['namaproduk'] ?? 'Tidak tersedia'}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Jumlah Produk: ${dtl['jumlahproduk']?.toString() ?? 'Tidak tersedia'}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'Subtotal: ${dtl['subtotal']?.toString() ?? 'Tidak tersedia'}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

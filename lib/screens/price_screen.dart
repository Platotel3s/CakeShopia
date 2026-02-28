// price_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shofy_management/app_color.dart';
import 'package:shofy_management/services/price_service.dart';
import '../models/model.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});
  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  final PriceService _priceApi = PriceService();
  List<Prices> _prices = [];
  bool _isLoading = true;
  final formatRupiah = NumberFormat.currency(
    locale: 'id',
    symbol: 'Rp',
    decimalDigits: 0
  );

  @override
  void initState() {
    super.initState();
    _loadPrices();
  }

  Future<void> _loadPrices() async {
    setState(() => _isLoading = true);
    _prices = await _priceApi.getPrices();
    setState(() => _isLoading = false);
  }

  void _showForm({Prices? price}) {
    final controller = TextEditingController(text: price?.harga.toString() ?? '');
    final isEditing = price != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEditing ? 'Edit Harga' : 'Tambah Harga',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Harga (Rp)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                  hintText: 'Contoh: 4000',
                ),
                keyboardType: TextInputType.number,
                autofocus: true,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Batal'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (controller.text.isEmpty) return;
                        
                        final harga = int.tryParse(controller.text) ?? 0;
                        if (harga <= 0) return;
                        
                        Map<String, dynamic> result;
                        if (isEditing) {
                          result = await _priceApi.updatePrice(price.id!, harga);
                        } else {
                          result = await _priceApi.createPrice(harga);
                        }
                        
                        Navigator.pop(context);
                        
                        if (result['status'] == 'success') {
                          _loadPrices();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result['message'] ?? 'Berhasil')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Gagal: ${result['message']}')),
                          );
                        }
                      },
                      child: Text(isEditing ? 'Update' : 'Simpan'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _deletePrice(int id) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hapus Harga?'),
        content: Text('Data yang dihapus tidak bisa dikembalikan'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Batal')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final result = await _priceApi.deletePrice(id);
              if (result['status'] == 'success') {
                _loadPrices();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Harga dihapus')),
                );
              }
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manajemen Harga'),
        backgroundColor: AppColor.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _prices.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.money_off, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Belum ada harga', style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showForm(),
                        icon: Icon(Icons.add),
                        label: Text('Tambah Harga'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _prices.length,
                  itemBuilder: (context, index) {
                    final price = _prices[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green.shade100,
                          child: Text('${index + 1}'),
                        ),
                        title: Text(formatRupiah.format(price.harga)),
                        subtitle: Text('Ditambahkan: ${price.createdAt}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showForm(price: price),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deletePrice(price.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: Icon(Icons.add),
        backgroundColor: AppColor.secondaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}

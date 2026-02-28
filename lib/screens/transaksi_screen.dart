import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shofy_management/app_color.dart';
import 'package:shofy_management/services/price_service.dart';
import 'package:shofy_management/services/transaksi_service.dart';
import '../models/model.dart';
import 'package:shofy_management/services/package_service.dart';
import 'package:shofy_management/services/topping_service.dart';


class TransaksiScreen extends StatefulWidget {
  const TransaksiScreen({super.key});

  @override
  State<TransaksiScreen> createState() => _TransaksiScreenState();
}

class _TransaksiScreenState extends State<TransaksiScreen> {
  final TransaksiService _transaksiApi = TransaksiService();
  final PackageService _packageApi = PackageService();
  final PriceService _priceApi = PriceService();
  final ToppingService _toppingApi = ToppingService();
  List<Packages> _packages = [];
  List<Prices> _prices = [];
  List<Toppings> _toppings = [];
  List<Transaksi> _transaksiList = [];
  int? _selectedPackage;
  int? _selectedPrice;
  List<int> _selectedToppings = [];
  
  bool _isLoading = true;
  bool _isSubmitting = false;
  
  final formatRupiah = NumberFormat.currency(
    locale: 'id', 
    symbol: 'Rp ', 
    decimalDigits: 0
  );

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      _packages = await _packageApi.getPackages();
      _prices = await _priceApi.getPrices();
      _toppings = await _toppingApi.getToppings();
      _transaksiList = await _transaksiApi.getTransaksi();
    } catch (e) {
      debugPrint('Error load data: $e');
      _showSnackBar('Gagal load data: $e', isError: true);
    }
    
    setState(() => _isLoading = false);
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  void _showFormTransaksi() {
    _selectedPackage = null;
    _selectedPrice = null;
    _selectedToppings = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Transaksi Baru',
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Pilih Paket', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _packages.map((pkg) {
                      bool isSelected = _selectedPackage == pkg.id;
                      return ChoiceChip(
                        label: Text('${pkg.satuan} (${pkg.isi} donat)'),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedPackage = selected ? pkg.id : null;
                          });
                        },
                        selectedColor: Colors.green.shade100,
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 16),
                  const Text('Pilih Harga', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _prices.map((price) {
                      bool isSelected = _selectedPrice == price.id;
                      return ChoiceChip(
                        label: Text(formatRupiah.format(price.harga)),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedPrice = selected ? price.id : null;
                          });
                        },
                        selectedColor: Colors.blue.shade100,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Pilih Topping', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${_selectedToppings.length} dipilih', 
                          style: TextStyle(color: Colors.green.shade700)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      itemCount: _toppings.length,
                      itemBuilder: (ctx, index) {
                        final topping = _toppings[index];
                        bool isSelected = _selectedToppings.contains(topping.id);
                        return CheckboxListTile(
                          title: Text(topping.namaTopping),
                          value: isSelected,
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                _selectedToppings.add(topping.id!);
                              } else {
                                _selectedToppings.remove(topping.id);
                              }
                            });
                          },
                          secondary: CircleAvatar(
                            backgroundColor: Colors.pink.shade100,
                            child: Text('${index + 1}'),
                          ),
                          activeColor: Colors.green,
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  if (_selectedPackage != null && _selectedPrice != null && _selectedToppings.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ringkasan:', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('📦 Paket: ${_packages.firstWhere((p) => p.id == _selectedPackage).satuan}'),
                          Text('💰 Harga: ${formatRupiah.format(_prices.firstWhere((p) => p.id == _selectedPrice).harga)}'),
                          Text('🍩 Topping: ${_selectedToppings.length} pilihan'),
                        ],
                      ),
                    ),
                  
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : () async {
                        if (_selectedPackage == null || 
                            _selectedPrice == null || 
                            _selectedToppings.isEmpty) {
                          _showSnackBar('Pilih semua field', isError: true);
                          return;
                        }
                        
                        setState(() => _isSubmitting = true);
                        
                        final result = await _transaksiApi.createTransaksi(
                          idPackage: _selectedPackage!,
                          idHarga: _selectedPrice!,
                          idToppings: _selectedToppings,
                        );
                        Navigator.pop(context); 
                        if (result['status'] == 'success') {
                          _loadData();
                          _showSnackBar('Transaksi berhasil disimpan');
                        } else {
                          _showSnackBar('Gagal: ${result['message']}', isError: true);
                        }
                        
                        setState(() => _isSubmitting = false);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.secondaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('SIMPAN TRANSAKSI', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteTransaksi(int id) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Transaksi?'),
        content: const Text('Data yang dihapus tidak bisa dikembalikan'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final result = await _transaksiApi.deleteTransaksi(id);
              if (result['status'] == 'success') {
                _loadData();
                _showSnackBar('Transaksi dihapus');
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaksi Penjualan'),
        backgroundColor: AppColor.secondaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: Colors.green,
              child: _transaksiList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long, size: 80, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          const Text(
                            'Belum ada transaksi',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _showFormTransaksi,
                            icon: const Icon(Icons.add),
                            label: const Text('Transaksi Baru'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.secondaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _transaksiList.length,
                      itemBuilder: (context, index) {
                        final t = _transaksiList[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: CircleAvatar(
                              backgroundColor: Colors.green.shade100,
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800,
                                ),
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  t.formattedDate,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    formatRupiah.format(t.price?.harga ?? 0),
                                    style: TextStyle(
                                      color: Colors.green.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text('Paket: ${t.package?.satuan ?? '-'}'),
                                Text('Topping: ${t.toppingsList}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTransaksi(t.id!),
                            ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showFormTransaksi, 
        backgroundColor: AppColor.secondaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

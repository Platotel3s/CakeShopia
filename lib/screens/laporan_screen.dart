import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shofy_management/app_color.dart';
import 'package:shofy_management/services/analisis_service.dart';

class LaporanScreen extends StatefulWidget {
  const LaporanScreen({super.key});

  @override
  State<LaporanScreen> createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  final AnalisisService _analisisApi = AnalisisService();

  bool _isLoading = true;

  Map<String, dynamic> _penjualanHariIni = {};
  List<Map<String, dynamic>> _topTopping = [];
  List<Map<String, dynamic>> _topPackage = [];

  final formatRupiah =
      NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _loadLaporan();
  }

  Future<void> _loadLaporan() async {
    setState(() => _isLoading = true);

    try {
      _penjualanHariIni = await _analisisApi.getPenjualanHariIni();
      _topTopping = await _analisisApi.getTopTopping();
      _topPackage = await _analisisApi.getTopPackage();
    } catch (e) {
      debugPrint("Error laporan: $e");
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan & Statistik"),
        backgroundColor: AppColor.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadLaporan,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSummaryCard(),
                  const SizedBox(height: 20),
                  _buildTopPackage(),
                  const SizedBox(height: 20),
                  _buildTopTopping(),
                ],
              ),
            ),
    );
  }

  Widget _buildSummaryCard() {
    final data = _penjualanHariIni['data'] ?? {};

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Penjualan Hari Ini",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _summaryItem(
                  "Total Transaksi",
                  "${data['total_transaksi'] ?? 0}",
                  Icons.receipt,
                ),
                _summaryItem(
                  "Total Omzet",
                  formatRupiah.format(data['total_omzet'] ?? 0),
                  Icons.attach_money,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _summaryItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.green, size: 30),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildTopPackage() {
    return _buildTopList("Top Paket Terlaris", _topPackage, "nama_package");
  }

  Widget _buildTopTopping() {
    return _buildTopList("Top Topping Terlaris", _topTopping, "nama_topping");
  }

  Widget _buildTopList(
      String title, List<Map<String, dynamic>> data, String keyName) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            if (data.isEmpty)
              const Text("Belum ada data")
            else
              Column(
                children: data.map((item) {
                  return ListTile(
                    leading: const Icon(Icons.star, color: Colors.orange),
                    title: Text(item[keyName] ?? "-"),
                    trailing: Text(
                      "${item['total'] ?? 0}x",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              )
          ],
        ),
      ),
    );
  }
}

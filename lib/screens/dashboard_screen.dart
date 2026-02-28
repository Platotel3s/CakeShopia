import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shofy_management/app_color.dart';
import 'package:shofy_management/models/model.dart';
import '../services/dashboard_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardService _service = DashboardService();
  DashboardData? data;
  bool isLoading = true;

  final formatRupiah = NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final result = await _service.getDashboard();
    setState(() {
      data = result;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.blueAccent)),
      );
    }

    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        title: const Text("Dashboard Penjualan", style: TextStyle(fontWeight: FontWeight.bold,color: AppColor.primaryColor)),
        elevation: 0,
        backgroundColor: AppColor.secondaryColor,
        foregroundColor: Colors.black,
        actions: [
          IconButton(onPressed: load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: load,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle("Ringkasan Hari Ini"),
              const SizedBox(height: 12),
              _buildSummaryGrid(),
              
              const SizedBox(height: 32),
              _buildSectionTitle("Tren Penjualan"),
              const SizedBox(height: 12),
              _buildChartCard(),

              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildRankingList("Top Paket", data!.topPackage, 'satuan', Icons.inventory_2)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildRankingList("Top Topping", data!.topTopping, 'namaTopping', Icons.auto_awesome)),
                ],
              ),

              const SizedBox(height: 32),
              _buildRekomendasiCard(),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey),
    );
  }

  Widget _buildSummaryGrid() {
    final summary = data!.summary;
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      int crossAxisCount = width > 600 ? 2 : 1;
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        childAspectRatio: width > 600 ? 3 : 2.5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          _buildStatCard("Total Omzet", formatRupiah.format(int.parse(summary['total_omzet'].toString())), Icons.payments, Colors.green),
          _buildStatCard("Total Transaksi", "${summary['total_transaksi']} Order", Icons.shopping_bag, Colors.blue),
        ],
      );
    });
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    return Container(
      height: 300,
      padding: const EdgeInsets.fromLTRB(10, 24, 24, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[200], strokeWidth: 1)),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text("H-${value.toInt()}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                ),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: data!.trend.asMap().entries.map((e) => FlSpot(e.key.toDouble(), double.parse(e.value['total'].toString()))).toList(),
              isCurved: true,
              color: Colors.blueAccent,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: true, color: Colors.blueAccent.withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingList(String title, List<dynamic> items, String keyName, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          child: Column(
            children: items.take(5).map((item) => ListTile(
              leading: Icon(icon, size: 20, color: Colors.orange),
              title: Text(item[keyName].toString(), style: const TextStyle(fontSize: 14)),
              trailing: Text("${item['total']}x", style: const TextStyle(fontWeight: FontWeight.bold)),
              dense: true,
            )).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRekomendasiCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.orange.shade700]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.white),
              SizedBox(width: 8),
              Text("Insight Bisnis", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Text(data!.rekomendasi, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
        ],
      ),
    );
  }
}

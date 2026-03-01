import 'package:flutter/material.dart';
import 'package:shofy_management/app_color.dart';
import 'package:shofy_management/screens/dashboard_screen.dart';
import 'package:shofy_management/screens/transaksi_screen.dart';
import '../screens/topping_screen.dart';
import '../screens/price_screen.dart';
import '../screens/package_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.icecream,
        'title': 'Toppings',
        'subtitle': 'Kelola varian topping',
        'color': AppColor.thirdColor,
        'count': 'daftar topping',
        'screen': ToppingScreen(),
      },
      {
        'icon': Icons.attach_money,
        'title': 'Prices',
        'subtitle': 'Kelola harga jual',
        'color': AppColor.thirdColor,
        'count': 'daftar harga',
        'screen': PriceScreen(),
      },
      {
        'icon': Icons.inventory,
        'title': 'Packages',
        'subtitle': 'Kelola jenis paket',
        'color': AppColor.thirdColor,
        'count': 'daftar paket',
        'screen': PackageScreen(),
      },
      {
        'icon': Icons.bar_chart,
        'title': 'Dashboard',
        'subtitle': 'Analisis penjualan',
        'color': AppColor.thirdColor,
        'count': 'statistik',
        'screen': DashboardScreen(),
      },
        {
        'icon': Icons.receipt,
        'title': 'Transaksi',
        'subtitle': 'Catat penjualan',
        'color': AppColor.thirdColor,
        'count': 'baru',
        'screen': const TransaksiScreen(),
      },
    ];
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CakeShopia Management',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              '',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: AppColor.secondaryColor,
        foregroundColor: AppColor.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Menyegarkan data...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'DASHBOARD',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColor.thirdColor,
                ),
              ),
            ),

            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => item['screen']),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            item['color'].withOpacity(0.1),
                            item['color'].withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: item['color'].withOpacity(0.3),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: item['color'].withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: -10,
                            right: -10,
                            child: Icon(
                              item['icon'],
                              size: 70,
                              color: item['color'].withOpacity(0.1),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: item['color'].withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        item['icon'],
                                        color: item['color'],
                                        size: 28,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      item['title'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: item['color'],
                                      ),
                                    ),
                                    Text(
                                      item['subtitle'],
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: AppColor.thirdColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: item['color'].withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    item['count'],
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: item['color'],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColor.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.storage, size: 14, color: AppColor.thirdColor),
                      SizedBox(width: 4),
                      Text(
                        '4 Tabel Utama',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColor.thirdColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.update,
                        size: 14,
                        color: Colors.brown.shade400,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'v1.0.0',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.brown.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shofy_management/models/model.dart';
import 'package:shofy_management/services/package_service.dart';
import 'package:shofy_management/services/price_service.dart';
import 'package:shofy_management/services/transaksi_service.dart';

class AnalisisService {
  static const String baseUrl = 'http://192.168.1.5/cake';
  Future<Map<String, dynamic>> getPenjualanHariIni() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api_transaksi.php?laporan=hari_ini'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'status': 'error', 'data': {}};
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getStatistikPenjualan(String periode) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api_transaksi.php?statistik=$periode'),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'status': 'error', 'data': {}};
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<List<Map<String, dynamic>>> getTopTopping() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api_transaksi.php?top=topping'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          List list = data['data'] ?? [];
          return list.map((item) => Map<String, dynamic>.from(item)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error getTopTopping: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTopPackage() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api_transaksi.php?top=package'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          List list = data['data'] ?? [];
          return list.map((item) => Map<String, dynamic>.from(item)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error getTopPackage: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getKombinasiFavorit() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api_transaksi.php?analisis=kombinasi'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          List list = data['data'] ?? [];
          return list.map((item) => Map<String, dynamic>.from(item)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error getKombinasiFavorit: $e');
      return [];
    }
  }

  Future<Transaksi?> getTransaksiById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api_transaksi.php?id=$id'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          Transaksi transaksi = Transaksi.fromJson(data['data']);
          await _loadTransaksiDetails(transaksi);
          return transaksi;
        }
      }
      return null;
    } catch (e) {
      debugPrint('❌ Error getTransaksiById: $e');
      return null;
    }
  }

    Future<void> _loadTransaksiDetails(Transaksi transaksi) async {
    try {
      List<Packages> packages = await PackageService().getPackages();
      transaksi.package = packages.firstWhere(
        (p) => p.id == transaksi.idPackage,
        orElse: () => Packages(satuan: 'Unknown', isi: 0),
      );
      List<Prices> prices = await PriceService().getPrices();
      transaksi.price = prices.firstWhere(
        (p) => p.id == transaksi.idHarga,
        orElse: () => Prices(harga: 0),
      );
      transaksi.toppings = await TransaksiService().getToppingsByTransaksi(transaksi.id!);
    } catch (e) {
      debugPrint('❌ Error load transaksi details: $e');
    }
  }
}

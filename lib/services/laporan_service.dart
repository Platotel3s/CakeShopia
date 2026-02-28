import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LaporanService {
  static const String baseUrl = 'http://192.168.1.5/cake';
  Future<Map<String, dynamic>> getSemuaProduk() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api_laporan.php?type=semua_produk'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'status': 'error', 'data': []};
    } catch (e) {
      debugPrint('❌ Error getSemuaProduk: $e');
      return {'status': 'error', 'data': []};
    }
  }

  Future<Map<String, dynamic>> getStatistikProduk() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api_laporan.php?type=statistik'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'status': 'error', 'data': {}};
    } catch (e) {
      debugPrint('Error getStatistikProduk: $e');
      return {'status': 'error', 'data': {}};
    }
  }

  Future<Map<String, dynamic>> getToppingPopuler() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api_laporan.php?type=topping_populer'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'status': 'error', 'data': []};
    } catch (e) {
      debugPrint('❌ Error getToppingPopuler: $e');
      return {'status': 'error', 'data': []};
    }
  }

  Future<Map<String, dynamic>> cariProduk(String keyword) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api_laporan.php?type=cari&keyword=$keyword'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'status': 'error', 'data': []};
    } catch (e) {
      debugPrint('❌ Error cariProduk: $e');
      return {'status': 'error', 'data': []};
    }
  }

  Future<Map<String, dynamic>> getLaporanPenjualan(String periode) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api_laporan.php?periode=$periode'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'status': 'error', 'message': 'Gagal load laporan'};
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }
  Future<List<Map<String, dynamic>>> getTopPackage() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api_laporan.php?type=top_package'),
    );
    final result = json.decode(response.body);
    return List<Map<String, dynamic>>.from(result['data']);
  }
  Future<List<Map<String, dynamic>>> getTopTopping() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api_laporan.php?type=topping_populer'),
    );
    final result = json.decode(response.body);
    return List<Map<String, dynamic>>.from(result['data']);
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/model.dart';

class PriceService {
  static const String baseUrl = 'http://localhost/cake';
  Future<List<Prices>> getPrices() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api_prices.php'));
      debugPrint('getPrices - Status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          List list = data['data'] ?? [];
          return list.map((json) => Prices.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error getPrices: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> createPrice(int harga) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api_prices.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'harga': harga}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updatePrice(int id, int harga) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api_prices.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id, 'harga': harga}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deletePrice(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api_prices.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }  
}

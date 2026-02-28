import 'package:flutter/material.dart';
import '../models/model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ToppingService{
  static const String baseUrl='http://localhost/cake';
    Future<List<Toppings>> getToppings() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api_toppings.php'));
      debugPrint('📡 getToppings - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          List list = data['data'] ?? [];
          return list.map((json) => Toppings.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error getToppings: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> createTopping(String nama) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api_toppings.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'namaTopping': nama}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateTopping(int id, String nama) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api_toppings.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id, 'namaTopping': nama}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteTopping(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api_toppings.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

}

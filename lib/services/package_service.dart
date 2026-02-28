import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/model.dart';

class PackageService {
  static const String baseUrl = 'http://192.168.1.5/cake';
  Future<List<Packages>> getPackages() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api_packages.php'));
      debugPrint('📡 getPackages - Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          List list = data['data'] ?? [];
          return list.map((json) => Packages.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      debugPrint('❌ Error getPackages: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>> createPackage(String satuan, int isi) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api_packages.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'satuan': satuan, 'isi': isi}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updatePackage(
    int id,
    String satuan,
    int isi,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api_packages.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id, 'satuan': satuan, 'isi': isi}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deletePackage(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api_packages.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }
}

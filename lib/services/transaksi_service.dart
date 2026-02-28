import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shofy_management/services/package_service.dart';
import 'package:shofy_management/services/price_service.dart';
import '../models/model.dart';

class TransaksiService {
  static const String baseUrl = 'http://localhost/cake';
  
  Future<List<Transaksi>>getTransaksi()async{
    try{
      final response=await http.get(Uri.parse('$baseUrl/api_transaksi.php'));
      debugPrint('Berhasil menampilkan transaksi : ${response.statusCode}');
      if(response.statusCode==200){
        final data=json.decode(response.body);
        if(data['status']=='success'){
          List list=data['data']??[];
          return list.map((json)=>Transaksi.fromJson(json)).toList();
        }
      }
      return [];
    }catch(e){
      debugPrint('Gagal menampilkan transaksi karena :$e');
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
      transaksi.toppings = await getToppingsByTransaksi(transaksi.id!);
    } catch (e) {
      debugPrint('❌ Error load transaksi details: $e');
    }
  }

  Future<List<Toppings>> getToppingsByTransaksi(int idTransaksi) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api_transaksi_toppings.php?id_transaksi=$idTransaksi',
        ),
      );

      debugPrint('getToppingsByTransaksi - Response: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          List list = data['data'] ?? [];
          List<Toppings> toppings = [];
          for (var item in list) {
            if (item['namaTopping'] != null) {
              toppings.add(
                Toppings(
                  id: item['id_topping'] != null
                      ? int.parse(item['id_topping'].toString())
                      : null,
                  namaTopping: item['namaTopping'] ?? '',
                  createdAt: item['createdAt'] ?? '',
                ),
              );
            } else if (item['topping'] != null) {
              toppings.add(Toppings.fromJson(item['topping']));
            }
          }

          debugPrint('Ditemukan ${toppings.length} toppings');
          return toppings;
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error _getToppingsByTransaksi: $e');
      return [];
    }
  }
  Future<Map<String, dynamic>> createTransaksi({
    required int idPackage,
    required int idHarga,
    required List<int> idToppings,
  }) async {
    try {
      if (idToppings.isEmpty) {
        return {'status': 'error', 'message': 'Pilih minimal 1 topping'};
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api_transaksi.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id_package': idPackage,
          'id_harga': idHarga,
          'id_toppings': idToppings,
        }),
      );
      debugPrint('createTransaksi response: ${response.body}');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'status': 'error', 'message': 'Gagal: ${response.statusCode}'};
    } catch (e) {
      debugPrint('❌ Error createTransaksi: $e');
      return {'status': 'error', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteTransaksi(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api_transaksi.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'id': id}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return {'status': 'error', 'message': 'Gagal hapus'};
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }
}

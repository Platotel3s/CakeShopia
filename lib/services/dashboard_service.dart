import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/model.dart';

class DashboardService {
  static const String baseUrl = 'http://192.168.1.5/cake';

  Future<DashboardData?> getDashboard() async {
    final response =
        await http.get(Uri.parse('$baseUrl/api_dashboard.php'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return DashboardData.fromJson(jsonData);
    }
    return null;
  }
}

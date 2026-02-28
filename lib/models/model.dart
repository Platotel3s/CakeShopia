import 'package:intl/intl.dart';

class Toppings {
  final int? id;
  final String namaTopping;
  final String createdAt;

  Toppings({this.id, required this.namaTopping, this.createdAt = ''});

  factory Toppings.fromJson(Map<String, dynamic> json) {
    return Toppings(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      namaTopping: json['namaTopping'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'namaTopping': namaTopping};
}

class Prices {
  final int? id;
  final int harga;
  final String createdAt;

  Prices({this.id, required this.harga, this.createdAt = ''});

  factory Prices.fromJson(Map<String, dynamic> json) {
    return Prices(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      harga: json['harga'] != null
          ? int.parse(
              json['harga'].toString().replaceAll(RegExp(r'[^0-9]'), ''),
            )
          : 0,
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'harga': harga};
}

class Packages {
  final int? id;
  final String satuan;
  final int isi;
  final String createdAt;

  Packages({
    this.id,
    required this.satuan,
    required this.isi,
    this.createdAt = '',
  });

  factory Packages.fromJson(Map<String, dynamic> json) {
    return Packages(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      satuan: json['satuan'] ?? '',
      isi: json['isi'] != null
          ? int.parse(json['isi'].toString().replaceAll(RegExp(r'[^0-9]'), ''))
          : 0,
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'satuan': satuan, 'isi': isi};
}

class Transaksi {
  final int? id;
  final int idPackage;
  final int idHarga;
  final String createdAt;
  List<Toppings>? toppings;
  Packages? package;
  Prices? price;

  Transaksi({
    this.id,
    required this.idPackage,
    required this.idHarga,
    this.createdAt = '',
    this.toppings,
    this.package,
    this.price,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: int.parse(json['id'].toString()),
      idPackage: int.parse(json['id_package'].toString()),
      idHarga: int.parse(json['id_harga'].toString()),
      createdAt: json['createdAt'] ?? '',
      package: json['package_name'] != null
          ? Packages(
              satuan: json['package_name'],
              isi: int.tryParse(json['package_isi'].toString()) ?? 0,
            )
          : null,
      price: json['price_amount'] != null
          ? Prices(harga: int.tryParse(json['price_amount'].toString()) ?? 0)
          : null,
      toppings: json['toppings'] != null
          ? List<Toppings>.from(
              json['toppings'].map(
                (t) => Toppings(
                  id: int.tryParse(t['id_topping'].toString()),
                  namaTopping: t['namaTopping'] ?? '',
                  createdAt: t['createdAt'] ?? '',
                ),
              ),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id_package': idPackage,
    'id_harga': idHarga,
  };

  int getTotalHarga() {
    if (price == null) return 0;
    return price!.harga;
  }

  String get formattedDate {
    try {
      final date = DateTime.parse(createdAt);
      return DateFormat('dd/MM/yy HH:mm').format(date);
    } catch (e) {
      return createdAt;
    }
  }

  String get toppingsList {
    if (toppings == null || toppings!.isEmpty) {
      return '-';
    }
    return toppings!.map((t) => t.namaTopping).join(', ');
  }
}

class TransaksiTopping {
  final int? id;
  final int idTransaksi;
  final int idTopping;
  final String createdAt;
  Toppings? topping;

  TransaksiTopping({
    this.id,
    required this.idTransaksi,
    required this.idTopping,
    this.createdAt = '',
    this.topping,
  });

  factory TransaksiTopping.fromJson(Map<String, dynamic> json) {
    return TransaksiTopping(
      id: json['id'] != null ? int.parse(json['id'].toString()) : null,
      idTransaksi: json['id_transaksi'] != null
          ? int.parse(json['id_transaksi'].toString())
          : 0,
      idTopping: json['id_topping'] != null
          ? int.parse(json['id_topping'].toString())
          : 0,
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id_transaksi': idTransaksi,
    'id_topping': idTopping,
  };
}

class DashboardData {
  final Map<String, dynamic> summary;
  final List<dynamic> trend;
  final List<dynamic> topPackage;
  final List<dynamic> topTopping;
  final String rekomendasi;

  DashboardData({
    required this.summary,
    required this.trend,
    required this.topPackage,
    required this.topTopping,
    required this.rekomendasi,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return DashboardData(
      summary: data['summary'] ?? {},
      trend: data['trend'] ?? [],
      topPackage: data['top_package'] ?? [],
      topTopping: data['top_topping'] ?? [],
      rekomendasi: data['rekomendasi'] ?? '',
    );
  }
}

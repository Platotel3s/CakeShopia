// topping_screen.dart
import 'package:flutter/material.dart';
import 'package:shofy_management/app_color.dart';
import 'package:shofy_management/services/topping_service.dart';
import '../models/model.dart';

class ToppingScreen extends StatefulWidget {
  const ToppingScreen({super.key});
  @override
  State<ToppingScreen> createState() => _ToppingScreenState();
}

class _ToppingScreenState extends State<ToppingScreen> {
  final ToppingService _toppinApi = ToppingService();
  List<Toppings> _toppings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadToppings();
  }

  Future<void> _loadToppings() async {
    setState(() => _isLoading = true);
    _toppings = await _toppinApi.getToppings();
    setState(() => _isLoading = false);
  }

  void _showForm({Toppings? topping}) {
    final controller = TextEditingController(text: topping?.namaTopping ?? '');
    final isEditing = topping != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEditing ? 'Edit Topping' : 'Tambah Topping',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Nama Topping',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.icecream),
                ),
                autofocus: true,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Batal'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (controller.text.isEmpty) return;
                        Map<String, dynamic> result;
                        if (isEditing) {
                          result = await _toppinApi.updateTopping(
                            topping.id!,
                            controller.text,
                          );
                        } else {
                          result = await _toppinApi.createTopping(controller.text);
                        }
                        Navigator.pop(context);
                        if (result['status'] == 'success') {
                          _loadToppings();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result['message'] ?? 'Berhasil'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Gagal: ${result['message']}'),
                            ),
                          );
                        }
                      },
                      child: Text(isEditing ? 'Update' : 'Simpan'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _deleteTopping(int id) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hapus Topping?'),
        content: Text('Data yang dihapus tidak bisa dikembalikan'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Batal')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final result = await _toppinApi.deleteTopping(id);
              if (result['status'] == 'success') {
                _loadToppings();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Topping dihapus')));
              }
            },
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manajemen Topping'),
        backgroundColor: AppColor.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _toppings.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.icecream, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada topping',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showForm(),
                    icon: Icon(Icons.add),
                    label: Text('Tambah Topping'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _toppings.length,
              itemBuilder: (context, index) {
                final topping = _toppings[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.pink.shade100,
                      child: Text('${index + 1}'),
                    ),
                    title: Text(topping.namaTopping),
                    subtitle: Text('Ditambahkan: ${topping.createdAt}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showForm(topping: topping),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteTopping(topping.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        backgroundColor: AppColor.secondaryColor,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}

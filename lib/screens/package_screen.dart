// package_screen.dart
import 'package:flutter/material.dart';
import 'package:shofy_management/app_color.dart';
import 'package:shofy_management/services/package_service.dart';
import '../models/model.dart';

class PackageScreen extends StatefulWidget {
  const PackageScreen({super.key});
  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  final PackageService _api = PackageService();
  List<Packages> _packages = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadPackages();
  }

  Future<void> _loadPackages() async {
    setState(() => _isLoading = true);
    try {
      _packages = await _api.getPackages();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal memuat data')));
    }
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  void _showForm({Packages? package}) {
    final satuanCtrl = TextEditingController(text: package?.satuan ?? '');
    final isiCtrl = TextEditingController(text: package?.isi.toString() ?? '');

    final bool isEditing = package != null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
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
                isEditing ? 'Edit Paket' : 'Tambah Paket',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: satuanCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nama Satuan',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory),
                  hintText: 'Contoh: Paket 3, Satuan, dll',
                ),
                autofocus: true,
              ),

              const SizedBox(height: 12),
              TextField(
                controller: isiCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Isi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.numbers),
                  hintText: 'Contoh: 3 untuk paket, 1 untuk satuan',
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (satuanCtrl.text.isEmpty || isiCtrl.text.isEmpty) {
                          return;
                        }
                        final int isi = int.tryParse(isiCtrl.text) ?? 0;
                        if (isi <= 0) return;
                        Map<String, dynamic> result;
                        try {
                          if (isEditing && package.id != null) {
                            result = await _api.updatePackage(
                              package.id!,
                              satuanCtrl.text,
                              isi,
                            );
                          } else {
                            result = await _api.createPackage(
                              satuanCtrl.text,
                              isi,
                            );
                          }
                        } catch (e) {
                          result = {
                            'status': 'error',
                            'message': 'Terjadi kesalahan',
                          };
                        }

                        if (!mounted) return;
                        Navigator.pop(context);

                        if (result['status'] == 'success') {
                          _loadPackages();
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
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _deletePackage(int id) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Paket?'),
        content: const Text('Data yang dihapus tidak bisa dikembalikan'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);

              final result = await _api.deletePackage(id);

              if (!mounted) return;

              if (result['status'] == 'success') {
                _loadPackages();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Paket dihapus')));
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Paket'),
        backgroundColor: AppColor.secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _packages.isEmpty
          ? _buildEmptyState()
          : _buildList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        backgroundColor: AppColor.secondaryColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inventory, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Belum ada paket', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => _showForm(),
            icon: const Icon(Icons.add),
            label: const Text('Tambah Paket'),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _packages.length,
      itemBuilder: (context, index) {
        final package = _packages[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text('${index + 1}'),
            ),
            title: Text('${package.satuan} (isi ${package.isi})'),
            subtitle: Text('Ditambahkan: ${package.createdAt}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showForm(package: package),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: package.id == null
                      ? null
                      : () => _deletePackage(package.id!),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

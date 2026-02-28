# 🎂 CakeShopia Management System

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![PHP](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white)](https://www.php.net)
[![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com)

Aplikasi manajemen toko kue modern yang dibangun dengan Flutter untuk menangani transaksi, pengelolaan stok topping, paket produk, dan analisis dashboard penjualan secara real-time.

---

## ✨ Fitur Utama
- 🛒 **Transaksi Cepat**: Pencatatan penjualan dengan sistem kalkulasi otomatis.
- 📊 **Dashboard Analitik**: Visualisasi data penjualan menggunakan grafik interaktif.
- 🍦 **Manajemen Topping**: Kelola berbagai varian rasa dan tambahan.
- 📦 **Paket Produk**: Pengaturan jenis paket kue dan harga jual.
- 🎨 **Modern UI**: Desain Glassmorphism yang responsif untuk Android & iOS.

---

## 🚀 Persiapan Teknis (Local Development)

### 1. Prasyarat
- Flutter SDK (Versi terbaru)
- Web Server (Apache/Nginx) & PHP 7.4+
- MySQL Database

### 2. Backend Setup (PHP)
1. Salin semua file dari folder `api/` ke web directory kamu (misal: `/var/www/html/cake/`).
2. Buat database baru bernama `cakeshopia` dan impor file SQL (jika ada).
3. Sesuaikan konfigurasi database pada file `config.php`.

### 3. Frontend Setup (Flutter)
1. Clone repositori ini:
   ```bash
   git clone [https://github.com/username/cakeshopia_management.git](https://github.com/username/cakeshopia_management.git)
   ```
2. Install Dependencies
   ```bash
   flutter pub get
   ```
3. Ubah baseUrl pada konfigurasi service Flutter dengan IP lokal laptop kamu (cek menggunakan ip addr).
4. Running
   ```bash
   flutter run
   ```
5. 

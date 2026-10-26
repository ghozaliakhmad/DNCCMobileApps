# VegBox - Aplikasi Perbelanjaan Flutter

Aplikasi demo belanja produk segar menggunakan Flutter.

## Fitur
- Halaman masuk/daftar demo dengan validasi input.
- Daftar sayuran dari Vegetables API dengan pencarian dan filter kategori.
- Detail produk dan pengaturan jumlah.
- Keranjang belanja, tambah/kurangi jumlah, hapus barang, dan total otomatis.
- Checkout simulasi dan riwayat pesanan selama aplikasi berjalan.
- Profil pelanggan, notifikasi, dan navigasi bawah.

## Menjalankan
1. Pastikan Flutter SDK sudah terpasang.
2. Buka folder `aplikasijb` di VS Code/Android Studio.
3. Jalankan `flutter pub get`.
4. Jalankan `flutter run` atau pilih perangkat Android.

## Catatan
Ini versi tugas/demo. Login belum memakai backend/database, dan checkout belum terhubung ke payment gateway. Riwayat pesanan hanya disimpan di memori selama aplikasi berjalan; data akan hilang ketika aplikasi ditutup.

## Vegetables API
- Dokumentasi: https://api-mobile.dnccudinus.org/ (bagian **VEGETABLES API**).
- Aplikasi mengambil data melalui `GET https://api-mobile.dnccudinus.org/api/vegetables`.
- Pencarian menggunakan parameter `cari`, sedangkan kategori menggunakan `kategori`.
- Nama, kategori, harga, gambar, dan deskripsi produk berasal dari respons API. Koneksi API atau format respons yang gagal akan ditampilkan di beranda beserta tombol untuk mencoba lagi.
- Beberapa URL gambar API yang sudah tidak aktif diarahkan ke gambar cadangan agar seluruh produk tetap tampil.

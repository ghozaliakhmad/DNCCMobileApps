import 'package:flutter/material.dart';
import '../main.dart';
import '../models/product_model.dart';
import '../widgets/product_image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: ShopStore.instance,
      builder: (context, _) {
        final store = ShopStore.instance;
        return Scaffold(
          appBar: AppBar(title: const Text('Keranjang Belanja')),
          body: store.cart.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_bag_outlined,
                          size: 72, color: Colors.black26),
                      SizedBox(height: 12),
                      Text(
                        'Keranjang masih kosong',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      Text('Yuk, pilih produk segar favoritmu!'),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: store.cart.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, i) {
                          final line = store.cart[i];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: 78,
                                    height: 78,
                                    child: ProductImage(
                                      imageUrl: line.product.imageUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        line.product.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        rupiah(line.product.price),
                                        style: const TextStyle(color: green),
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            visualDensity:
                                                VisualDensity.compact,
                                            onPressed: () =>
                                                store.changeQuantity(
                                                    line.product, -1),
                                            icon: const Icon(
                                                Icons.remove_circle_outline),
                                          ),
                                          Text('${line.quantity}'),
                                          IconButton(
                                            visualDensity:
                                                VisualDensity.compact,
                                            onPressed: () =>
                                                store.changeQuantity(
                                                    line.product, 1),
                                            icon: const Icon(
                                              Icons.add_circle_outline,
                                              color: green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => store.remove(line.product),
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Total belanja',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Text(
                                rupiah(store.total),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: green,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: green,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () => _checkout(context, store),
                              child: const Text('Lanjutkan Pembelian'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        );
      });

  static Future<void> _checkout(BuildContext context, ShopStore store) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi pesanan'),
        content: Text(
          'Buat pesanan dengan total ${rupiah(store.total)}?\n\n'
          'Versi tugas ini menggunakan checkout simulasi, '
          'belum terhubung ke pembayaran asli.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Kembali'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Buat Pesanan'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      store.checkout();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pesanan berhasil dibuat!')),
      );
    }
  }
}

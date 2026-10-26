import 'package:flutter/material.dart';
import '../main.dart';
import '../models/product_model.dart';
import '../widgets/product_image.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int quantity = 1;
  bool showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 320,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: ProductImage(
                            imageUrl: product.imageUrl,
                            fit: BoxFit.contain,
                            iconSize: 110,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      left: 18,
                      child: Material(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        elevation: 2,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () => Navigator.pop(context),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                Icon(Icons.arrow_back_rounded,
                                    color: green, size: 18),
                                SizedBox(width: 5),
                                Text(
                                  'Kembali',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 23,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category,
                      style: const TextStyle(color: muted, fontSize: 11),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: paleGreen,
                            borderRadius: BorderRadius.circular(7),
                          ),
                          child: const Text(
                            'SEGAR',
                            style: TextStyle(
                              color: darkGreen,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 9),
                        Text(
                          rupiah(product.price),
                          style: const TextStyle(
                            color: green,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        _QuantityButton(
                          icon: Icons.remove_rounded,
                          enabled: quantity > 1,
                          onTap: () {
                            if (quantity > 1) setState(() => quantity--);
                          },
                        ),
                        SizedBox(
                          width: 34,
                          child: Text(
                            '$quantity',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _QuantityButton(
                          icon: Icons.add_rounded,
                          enabled: true,
                          onTap: () => setState(() => quantity++),
                        ),
                      ],
                    ),
                    const SizedBox(height: 19),
                    const Text(
                      'Deskripsi',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      product.description,
                      maxLines: showFullDescription ? null : 3,
                      overflow: showFullDescription
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: muted,
                        fontSize: 11,
                        height: 1.6,
                      ),
                    ),
                    TextButton(
                      onPressed: () => setState(
                          () => showFullDescription = !showFullDescription),
                      style: TextButton.styleFrom(
                        foregroundColor: green,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 28),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        showFullDescription
                            ? 'Lebih sedikit  ↑'
                            : 'Selengkapnya  ›',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Divider(height: 28),
                    const Row(
                      children: [
                        Icon(Icons.verified_rounded, color: green, size: 18),
                        SizedBox(width: 7),
                        Text(
                          'Dipilih segar untukmu',
                          style: TextStyle(
                            color: darkGreen,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEDEEEF))),
            boxShadow: [
              BoxShadow(
                color: Color(0x0A000000),
                blurRadius: 12,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
              ),
              onPressed: () {
                ShopStore.instance.add(product, quantity);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Produk ditambahkan ke keranjang'),
                    duration: Duration(seconds: 1),
                  ),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.shopping_basket_rounded, size: 18),
              label: Text(
                'Tambah ke Keranjang • ${rupiah(product.price * quantity)}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: enabled ? paleGreen : const Color(0xFFF3F4F4),
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 30,
            height: 30,
            child: Icon(
              icon,
              color: enabled ? green : const Color(0xFFB8BBC0),
              size: 19,
            ),
          ),
        ),
      );
}

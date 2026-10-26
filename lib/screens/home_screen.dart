import 'dart:async';

import 'package:flutter/material.dart';
import '../main.dart';
import '../models/product_model.dart';
import '../services/vegetable_api.dart';
import '../widgets/product_image.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.vegetableApi});

  final VegetableApi? vegetableApi;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchController = TextEditingController();
  late final VegetableApi _vegetableApi = widget.vegetableApi ?? VegetableApi();
  Timer? searchDebounce;
  final allProducts = <Product>[];
  List<Product> products = [];
  String? errorMessage;
  String category = 'Semua';
  bool isLoading = true;
  int requestNumber = 0;

  List<String> get categories => [
        'Semua',
        ...allProducts.map((product) => product.category).toSet(),
      ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchDebounce?.cancel();
    if (widget.vegetableApi == null) _vegetableApi.close();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    final currentRequest = ++requestNumber;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await _vegetableApi.fetchVegetables(
        category: category,
        search: searchController.text,
      );
      if (!mounted || currentRequest != requestNumber) return;
      setState(() {
        products = result;
        if (category == 'Semua' && searchController.text.trim().isEmpty) {
          allProducts
            ..clear()
            ..addAll(result);
        }
        isLoading = false;
      });
    } on Exception catch (error) {
      if (!mounted || currentRequest != requestNumber) return;
      setState(() {
        errorMessage = error.toString().replaceFirst('Exception: ', '');
        products = [];
        isLoading = false;
      });
    }
  }

  void _scheduleSearch() {
    searchDebounce?.cancel();
    searchDebounce = Timer(
      const Duration(milliseconds: 350),
      _loadProducts,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Antar ke',
                          style: TextStyle(color: muted, fontSize: 12),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                color: green, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              ShopStore.instance.customerName ==
                                      'Pelanggan VegBox'
                                  ? 'Rumah saya'
                                  : 'Rumah ${ShopStore.instance.customerName}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.keyboard_arrow_down_rounded,
                                size: 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: paleGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.eco_rounded,
                        color: darkGreen, size: 23),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SizedBox(
                  height: 218,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/banner_hero.png',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: .98),
                              Colors.white.withValues(alpha: .88),
                              Colors.white.withValues(alpha: 0),
                            ],
                            stops: const [0, .47, 1],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 14, 116, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Segar setiap hari',
                              style: TextStyle(
                                color: darkGreen,
                                fontSize: 23,
                                height: 1.15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Belanja bahan pilihan untuk keluarga.',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF555D53),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: green,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'PILIH PRODUK',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: .4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 19),
              child: TextField(
                controller: searchController,
                onChanged: (_) {
                  setState(() {});
                  _scheduleSearch();
                },
                decoration: InputDecoration(
                  hintText: 'Cari kebutuhan harianmu?',
                  prefixIcon: const Icon(Icons.search_rounded, color: green),
                  suffixIcon: searchController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            setState(() {});
                            _loadProducts();
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFFE8EAEC)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xFFE8EAEC)),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kategori',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() => category = 'Semua');
                      _loadProducts();
                    },
                    style: TextButton.styleFrom(foregroundColor: green),
                    child: const Text(
                      'Lihat semua  ›',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 42,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final item = categories[index];
                  final selected = category == item;
                  return ChoiceChip(
                    label: Text(item),
                    selected: selected,
                    showCheckmark: false,
                    selectedColor: paleGreen,
                    backgroundColor: Colors.white,
                    side: BorderSide(
                        color: selected ? paleGreen : const Color(0xFFF0F1F2)),
                    labelStyle: TextStyle(
                      color: selected ? darkGreen : muted,
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    onSelected: (_) {
                      setState(() => category = item);
                      _loadProducts();
                    },
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Produk pilihan',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    isLoading && products.isEmpty
                        ? 'Memuat...'
                        : '${products.length} produk',
                    style: const TextStyle(color: muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading && products.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(color: green),
              ),
            )
          else if (errorMessage != null && products.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off_rounded,
                          size: 42, color: muted),
                      const SizedBox(height: 12),
                      const Text(
                        'Tidak dapat memuat sayuran',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: muted, fontSize: 12),
                      ),
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        onPressed: _loadProducts,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Coba lagi'),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (!isLoading && products.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: Center(child: Text('Produk tidak ditemukan.')),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 24),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index];
                    return _ProductCard(product: product);
                  },
                  childCount: products.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: .69,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        child: InkWell(
          borderRadius: BorderRadius.circular(19),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: product),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              border: Border.all(color: const Color(0xFFE9EAEC)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x08000000),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 5),
                  child: AspectRatio(
                    aspectRatio: 1.12,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: ProductImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(11, 0, 11, 11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: muted, fontSize: 10),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              rupiah(product.price),
                              style: const TextStyle(
                                color: darkGreen,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Material(
                            color: paleGreen,
                            borderRadius: BorderRadius.circular(9),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(9),
                              onTap: () {
                                ShopStore.instance.add(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${product.name} ditambahkan ke keranjang'),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: const SizedBox(
                                width: 30,
                                height: 30,
                                child: Icon(Icons.add_rounded,
                                    color: green, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

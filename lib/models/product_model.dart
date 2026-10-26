class Product {
  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.description,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['nama'];
    final category = json['kategori'];
    final price = json['harga'];
    final imageUrl = json['gambar'];
    final description = json['deskripsi'];

    if (id == null ||
        name is! String ||
        category is! String ||
        price is! num ||
        imageUrl is! String ||
        description is! String) {
      throw const FormatException('Format data sayuran dari API tidak valid.');
    }

    var resolvedImageUrl = imageUrl;
    for (final replacement in _brokenVegetableImageUrls.entries) {
      if (resolvedImageUrl.contains(replacement.key)) {
        resolvedImageUrl = replacement.value;
        break;
      }
    }

    return Product(
      id: id.toString(),
      name: name,
      category: category,
      price: price.toInt(),
      imageUrl: resolvedImageUrl,
      description: description,
    );
  }

  final String id;
  final String name;
  final String imageUrl;
  final int price;
  final String category;
  final String description;
}

const _brokenVegetableImageUrls = {
  'photo-1574316071802-0d684efa7cd5':
      'https://upload.wikimedia.org/wikipedia/commons/b/b9/Mustard_greens_on_a_tray.jpg',
  'Ipomoea_aquatica.jpg/640px-Ipomoea_aquatica.jpg':
      'https://thumb.wikimedia.org/wikipedia/commons/thumb/5/55/Kangkung_segar.jpg/960px-Kangkung_segar.jpg',
  'photo-1615484477778-ca3b783256fd':
      'https://thumb.wikimedia.org/wikipedia/commons/thumb/3/30/Italian_Eggplants_On_Sale_In_Fruit_and_Vegetable_Store.jpg/960px-Italian_Eggplants_On_Sale_In_Fruit_and_Vegetable_Store.jpg',
  'Long_Bean.JPG/640px-Long_Bean.JPG':
      'https://thumb.wikimedia.org/wikipedia/commons/thumb/7/78/Long_Bean.JPG/960px-Long_Bean.JPG',
};

String rupiah(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    buffer.write(digits[i]);
    final remaining = digits.length - i - 1;
    if (remaining > 0 && remaining % 3 == 0) buffer.write('.');
  }
  return 'Rp${buffer.toString()}';
}

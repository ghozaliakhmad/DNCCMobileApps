import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vegbox/main.dart';
import 'package:vegbox/services/vegetable_api.dart';
import 'package:vegbox/widgets/product_image.dart';

void main() {
  testWidgets('VegBox login and shopping flow works', (tester) async {
    tester.view.physicalSize = const Size(393, 873);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final client = MockClient((_) async => http.Response(
          '{"success":true,"data":${jsonEncode(_vegetables)}}',
          200,
          headers: {'content-type': 'application/json'},
        ));
    final vegetableApi = VegetableApi(client: client);
    addTearDown(vegetableApi.close);

    await tester.pumpWidget(VegBoxApp(vegetableApi: vegetableApi));
    await tester.pumpAndSettle();

    expect(find.text('Selamat datang di VegBox'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'Masuk'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), '08123456789');
    await tester.enterText(find.byType(TextFormField).at(1), '1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Masuk'));
    await tester.pumpAndSettle();

    expect(find.text('Segar setiap hari'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.notifications_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Notifikasi'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.receipt_long_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada pesanan'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.person_outline_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Profil'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.home_rounded));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Wortel Berastagi').first);
    await tester.pumpAndSettle();
    expect(find.text('Deskripsi'), findsOneWidget);
    final productImage = tester.widget<ProductImage>(find.byType(ProductImage));
    expect(productImage.imageUrl, 'https://example.com/wortel.jpg');

    await tester.tap(find.textContaining('Tambah ke Keranjang'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.shopping_basket_rounded).first);
    await tester.pumpAndSettle();
    expect(find.text('Keranjang Belanja'), findsOneWidget);
    expect(find.text('Wortel Berastagi'), findsOneWidget);
  });
}

const _vegetables = [
  {
    'id': 1,
    'nama': 'Bayam Hijau',
    'kategori': 'Sayuran Daun',
    'harga': 3500,
    'gambar': 'https://example.com/bayam.jpg',
    'deskripsi': 'Bayam hijau segar.',
  },
  {
    'id': 2,
    'nama': 'Wortel Berastagi',
    'kategori': 'Sayuran Umbi',
    'harga': 8000,
    'gambar': 'https://example.com/wortel.jpg',
    'deskripsi': 'Wortel manis dan renyah.',
  },
];

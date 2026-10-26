import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:vegbox/models/product_model.dart';
import 'package:vegbox/services/vegetable_api.dart';

void main() {
  test('fetches vegetables using the documented filter parameters', () async {
    Uri? requestedUri;
    final client = MockClient((request) async {
      requestedUri = request.url;
      return http.Response(
        jsonEncode({
          'success': true,
          'data': [_bayam],
        }),
        200,
      );
    });
    final api = VegetableApi(client: client);
    addTearDown(api.close);

    final products = await api.fetchVegetables(
      category: 'Sayuran Daun',
      search: 'Bayam',
    );

    expect(requestedUri?.scheme, 'https');
    expect(requestedUri?.host, 'api-mobile.dnccudinus.org');
    expect(requestedUri?.path, '/api/vegetables');
    expect(requestedUri?.queryParameters, {
      'kategori': 'Sayuran Daun',
      'cari': 'Bayam',
    });
    expect(products, hasLength(1));
    expect(products.single.id, '1');
    expect(products.single.name, 'Bayam Hijau');
    expect(products.single.price, 3500);
    expect(products.single.imageUrl, 'https://example.com/bayam.jpg');
  });

  test('does not send empty filters', () async {
    Uri? requestedUri;
    final client = MockClient((request) async {
      requestedUri = request.url;
      return http.Response(
        jsonEncode({
          'success': true,
          'data': [_bayam]
        }),
        200,
      );
    });
    final api = VegetableApi(client: client);
    addTearDown(api.close);

    await api.fetchVegetables(category: 'Semua', search: '  ');

    expect(requestedUri?.queryParameters, isEmpty);
  });

  test('reports unsuccessful API responses instead of returning fake data',
      () async {
    final client = MockClient((_) async => http.Response(
          jsonEncode({'success': false, 'data': []}),
          200,
        ));
    final api = VegetableApi(client: client);
    addTearDown(api.close);

    await expectLater(
      api.fetchVegetables(),
      throwsA(isA<FormatException>()),
    );
  });

  test('repairs image URLs that are broken in the API response', () {
    final kangkung = Product.fromJson({
      ..._bayam,
      'id': 2,
      'nama': 'Kangkung',
      'gambar':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Ipomoea_aquatica.jpg/640px-Ipomoea_aquatica.jpg',
    });
    final sawi = Product.fromJson({
      ..._bayam,
      'id': 3,
      'nama': 'Sawi Hijau',
      'gambar':
          'https://images.unsplash.com/photo-1574316071802-0d684efa7cd5?auto=format&fit=crop&w=600&q=80',
    });
    final terong = Product.fromJson({
      ..._bayam,
      'id': 7,
      'nama': 'Terong Ungu',
      'gambar':
          'https://images.unsplash.com/photo-1615484477778-ca3b783256fd?auto=format&fit=crop&w=600&q=80',
    });
    final kacangPanjang = Product.fromJson({
      ..._bayam,
      'id': 15,
      'nama': 'Kacang Panjang',
      'gambar':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/7/78/Long_Bean.JPG/640px-Long_Bean.JPG',
    });

    expect(kangkung.imageUrl, contains('Kangkung_segar.jpg/960px-'));
    expect(sawi.imageUrl, contains('Mustard_greens_on_a_tray.jpg'));
    expect(terong.imageUrl, contains('Italian_Eggplants_On_Sale'));
    expect(kacangPanjang.imageUrl, contains('Long_Bean.JPG/960px-'));
  });
}

const _bayam = {
  'id': 1,
  'nama': 'Bayam Hijau',
  'kategori': 'Sayuran Daun',
  'harga': 3500,
  'gambar': 'https://example.com/bayam.jpg',
  'deskripsi': 'Bayam hijau segar.',
};

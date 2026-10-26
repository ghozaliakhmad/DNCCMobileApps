import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../models/product_model.dart';

class VegetableApi {
  VegetableApi({http.Client? client}) : _client = client ?? http.Client();

  static final Uri _endpoint =
      Uri.https('api-mobile.dnccudinus.org', '/api/vegetables');

  final http.Client _client;

  Future<List<Product>> fetchVegetables({
    String? category,
    String? search,
  }) async {
    final queryParameters = <String, String>{};
    if (category != null && category.isNotEmpty && category != 'Semua') {
      queryParameters['kategori'] = category;
    }
    if (search != null && search.trim().isNotEmpty) {
      queryParameters['cari'] = search.trim();
    }

    final uri = _endpoint.replace(
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
    );
    final response = await _client
        .get(uri, headers: const {'Accept': 'application/json'}).timeout(
      const Duration(seconds: 15),
      onTimeout: () => throw const SocketException(
        'Permintaan ke API sayuran melewati batas waktu.',
      ),
    );

    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
        'API sayuran merespons dengan status ${response.statusCode}.',
        uri: uri,
      );
    }

    final dynamic decoded;
    try {
      decoded = jsonDecode(utf8.decode(response.bodyBytes));
    } on FormatException {
      throw const FormatException(
          'API sayuran mengirim JSON yang tidak valid.');
    }

    if (decoded is! Map<String, dynamic> || decoded['success'] != true) {
      throw const FormatException(
        'API sayuran tidak mengembalikan respons yang berhasil.',
      );
    }

    final data = decoded['data'];
    if (data is! List) {
      throw const FormatException(
        'Daftar sayuran tidak tersedia pada respons API.',
      );
    }

    return data.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException(
          'Format data sayuran dari API tidak valid.',
        );
      }
      return Product.fromJson(item);
    }).toList();
  }

  void close() => _client.close();
}

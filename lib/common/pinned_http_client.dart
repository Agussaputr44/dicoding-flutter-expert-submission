// lib/data/utils/ssl_pinning.dart
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

class SslPinning {
  static Future<IOClient> ioClientStrict({
    String assetPemPath = 'assets/certificates.cer',
  }) async {
    try {
      final data = await rootBundle.load(assetPemPath);
      final bytes = data.buffer.asUint8List();
      if (bytes.isEmpty) {
        throw const SslPinningException("File sertifikat kosong");
      }

      final context = SecurityContext(withTrustedRoots: false);
      context.setTrustedCertificatesBytes(bytes);

      final httpClient = HttpClient(context: context)
        ..connectionTimeout = const Duration(seconds: 20)
        ..badCertificateCallback = (X509Certificate cert, String host, int port) {
          return false; // jangan bypass
        };

      return IOClient(httpClient);
    } catch (e) {
      throw const SslPinningException("SSL gagal: sertifikat tidak valid / tidak ditemukan");
    }
  }
}

class SslPinningException implements Exception {
  final String message;
  const SslPinningException(this.message);

  @override
  String toString() => message;
}

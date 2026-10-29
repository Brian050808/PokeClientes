import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import 'app_db.dart';

/// Error de autenticación con los mismos códigos que usaba Firebase,
/// para que las pantallas sigan mostrando los mismos mensajes.
class AuthException implements Exception {
  final String code;
  final String message;
  AuthException(this.code, [this.message = '']);
  @override
  String toString() => 'AuthException($code): $message';
}

/// Usuarios guardados localmente en el dispositivo (SQLite).
class AuthService {
  static final _correoValido = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  String _hash(String sal, String password) {
    final bytes = utf8.encode('$sal$password');
    var digest = sha256.convert(bytes);
    for (var i = 0; i < 10000; i++) {
      digest = sha256.convert([...digest.bytes, ...bytes]);
    }
    return digest.toString();
  }

  String _nuevaSal() {
    final r = Random.secure();
    return base64UrlEncode(List<int>.generate(16, (_) => r.nextInt(256)));
  }

  Future<void> registrar({required String email, required String password}) async {
    final correo = email.trim().toLowerCase();
    if (!_correoValido.hasMatch(correo)) throw AuthException('invalid-email');
    if (password.length < 6) throw AuthException('weak-password');

    final d = await AppDb.instancia.db;
    final existe = await d.query('usuarios',
        where: 'correo = ?', whereArgs: [correo], limit: 1);
    if (existe.isNotEmpty) throw AuthException('email-already-in-use');

    final sal = _nuevaSal();
    await d.insert('usuarios',
        {'correo': correo, 'sal': sal, 'hash': _hash(sal, password)});
  }

  Future<void> iniciarSesion({required String email, required String password}) async {
    final correo = email.trim().toLowerCase();
    if (!_correoValido.hasMatch(correo)) throw AuthException('invalid-email');

    final d = await AppDb.instancia.db;
    final filas = await d.query('usuarios',
        where: 'correo = ?', whereArgs: [correo], limit: 1);
    if (filas.isEmpty ||
        _hash(filas.first['sal'] as String, password) != filas.first['hash']) {
      throw AuthException('invalid-credential');
    }
  }
}

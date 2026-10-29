import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Base de datos local (SQLite). Sustituye a Cloud Firestore.
class AppDb {
  AppDb._();
  static final AppDb instancia = AppDb._();

  Database? _db;
  final StreamController<String> _cambios = StreamController<String>.broadcast();

  Future<Database> get db async => _db ??= await _abrir();

  Future<Database> _abrir() async {
    final ruta = p.join(await getDatabasesPath(), 'proyecto10ids1.db');
    return openDatabase(
      ruta,
      version: 1,
      onCreate: (d, _) async {
        await d.execute('CREATE TABLE usuarios('
            'correo TEXT PRIMARY KEY, sal TEXT NOT NULL, hash TEXT NOT NULL)');
        await d.execute('CREATE TABLE clientes('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, '
            'telefono TEXT, correo TEXT, clasificacion TEXT)');
        await d.execute('CREATE TABLE clasificaciones('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT)');
      },
    );
  }

  Future<List<Map<String, Object?>>> _todos(String tabla) async {
    final d = await db;
    return d.query(tabla, orderBy: 'id ASC');
  }

  /// Emite la lista completa al suscribirse y cada vez que la tabla cambia.
  Stream<List<Map<String, Object?>>> observar(String tabla) {
    late StreamController<List<Map<String, Object?>>> salida;
    StreamSubscription<String>? sub;
    salida = StreamController<List<Map<String, Object?>>>(
      onListen: () async {
        sub = _cambios.stream.listen((t) async {
          if (t == tabla && !salida.isClosed) {
            salida.add(await _todos(tabla));
          }
        });
        try {
          salida.add(await _todos(tabla));
        } catch (e, st) {
          salida.addError(e, st);
        }
      },
      onCancel: () => sub?.cancel(),
    );
    return salida.stream;
  }

  Future<void> insertar(String tabla, Map<String, Object?> datos) async {
    final d = await db;
    await d.insert(tabla, datos);
    _cambios.add(tabla);
  }

  Future<void> actualizar(
      String tabla, String id, Map<String, Object?> datos) async {
    final d = await db;
    await d.update(tabla, datos, where: 'id = ?', whereArgs: [int.parse(id)]);
    _cambios.add(tabla);
  }

  Future<void> eliminar(String tabla, String id) async {
    final d = await db;
    await d.delete(tabla, where: 'id = ?', whereArgs: [int.parse(id)]);
    _cambios.add(tabla);
  }
}

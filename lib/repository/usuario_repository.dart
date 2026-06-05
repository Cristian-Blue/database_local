import 'package:local/constants/database_constants.dart';
import 'package:local/helpers/database_helper.dart';
import 'package:local/models/movimiento_model.dart';
import 'package:local/models/usuario_model.dart';

class UsuarioRepository {
  Future<int> insertUsuario(UsuarioModel usuario) async {
    final db = await DatabaseHelper().database;
    return await db.insert(usuarioDB['table']!, usuario.toMap());
  }

  Future<List<MovimientoModel>> getUsuarios() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(usuarioDB['table']!);
    return List.generate(maps.length, (i) {
      return MovimientoModel.fromMap(maps[i]);
    });
  }

  Future<List<MovimientoModel>> getUsuario(
    String email,
    String password,
  ) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      usuarioDB['table']!,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return List.generate(maps.length, (i) {
      return MovimientoModel.fromMap(maps[i]);
    });
  }

  Future<int> updateUsuario(UsuarioModel usuario) async {
    final db = await DatabaseHelper().database;
    return await db.update(
      usuarioDB['table']!,
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<int> deleteUsuario(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      usuarioDB['table']!,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

import 'package:local/constants/database_constants.dart';
import 'package:local/helpers/database_helper.dart';
import 'package:local/models/movimiento_model.dart';

class MovimientoRepository {
  Future<int> insertMovimiento(MovimientoModel movimiento) async {
    final db = await DatabaseHelper().database;
    return await db.insert(movimientoDB['table']!, movimiento.toMap());
  }

  Future<List<MovimientoModel>> getMovimientos() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> maps = await db.query(
      movimientoDB['table']!,
    );
    return List.generate(maps.length, (i) {
      return MovimientoModel.fromMap(maps[i]);
    });
  }

  Future<int> updateMovimiento(MovimientoModel movimiento) async {
    final db = await DatabaseHelper().database;
    return await db.update(
      movimientoDB['table']!,
      movimiento.toMap(),
      where: 'id = ?',
      whereArgs: [movimiento.id],
    );
  }

  Future<int> deleteMovimiento(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      movimientoDB['table']!,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

import 'package:local/constants/database_constants.dart';
import 'package:local/helpers/database_helper.dart';
import 'package:local/models/movimiento_model.dart';

class MovimientoRepository {
  Future<Map<String, double>> getResumenFinanciero() async {
    final db = await DatabaseHelper().database;

    final result = await db.rawQuery('''
    SELECT
      COALESCE(
        SUM(
          CASE
            WHEN tipo = 'ingreso' THEN valor
            ELSE 0
          END
        ), 0
      ) AS ingresos,

      COALESCE(
        SUM(
          CASE
            WHEN tipo = 'gasto' THEN valor
            ELSE 0
          END
        ), 0
      ) AS gastos,

      COALESCE(
        SUM(
          CASE
            WHEN tipo = 'ingreso' THEN valor
            WHEN tipo = 'gasto' THEN -valor
            ELSE 0
          END
        ), 0
      ) AS balance

    FROM movimientos
  ''');

    final row = result.first;

    return {
      'ingresos': (row['ingresos'] as num).toDouble(),
      'gastos': (row['gastos'] as num).toDouble(),
      'balance': (row['balance'] as num).toDouble(),
    };
  }

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

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE movimientos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tipo TEXT,
        descripcion TEXT,
        valor REAL,
        fecha TEXT
      )
    ''');
  }

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('movimientos.db');
    return _database!;
  }

  Future close() async {
    final db = _database;

    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}

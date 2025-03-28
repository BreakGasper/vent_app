import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'db_constants.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(dbName);
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, filePath);
    return await openDatabase(path, version: dbVersion, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE $tablePedidos (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnSkuCode TEXT NOT NULL,
        $columnEstatus TEXT NOT NULL,
        $columnIdUsuario TEXT NOT NULL,
        $columnPrecio REAL NOT NULL,
        $columnCantidad INTEGER NOT NULL,
        $columnDisponible INTEGER NOT NULL
      )
    ''');

    await db.execute(''' 
      CREATE TABLE $tableFavoritos (
        $columnFavId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnFavSkuCode TEXT NOT NULL UNIQUE,
        $columnFavNombre TEXT NOT NULL,
        $columnFavDescripcion TEXT NOT NULL,
        $columnFavPrecio REAL NOT NULL,
        $columnFavStock INTEGER NOT NULL,
        $columnFavUrl TEXT NOT NULL,
        $columnFavUnidadMedida TEXT NOT NULL,
        $columnFavProveedor TEXT NOT NULL,
        $columnFavFechaRegistro TEXT NOT NULL,
        $columnFavStatus TEXT NOT NULL,
        $columnFavPromocion INTEGER NOT NULL,
        $columnFavAlmacen TEXT NOT NULL,
        $columnFavCategoria TEXT NOT NULL,
        $columnFavFavorito INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }
}

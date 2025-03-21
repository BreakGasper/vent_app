// DatabaseHelper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

const String tableArticles = 'articles';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnImage = 'image';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('articles.db');
    return _database!;
  }

  // Abrir la base de datos
  Future<Database> _initDB(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, filePath);
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Crear la tabla
  Future _createDB(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE $tableArticles (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnImage TEXT NOT NULL
      )
    ''');
  }

  // Insertar un artículo en la base de datos
  Future<int> insertArticle(Map<String, dynamic> row) async {
    final db = await instance.database;
    return await db.insert(tableArticles, row);
  }

  // Obtener todos los artículos de la base de datos
  Future<List<Map<String, dynamic>>> getArticles() async {
    final db = await instance.database;
    return await db.query(tableArticles);
  }

  // Verificar si un artículo existe en la base de datos por su título
  Future<bool> doesArticleExist(Map<String, String> article) async {
    final db = await instance.database;

    final result = await db.query(
      tableArticles,
      where: '$columnTitle = ?', // Buscamos por el título
      whereArgs: [
        article[columnTitle],
      ], // Usamos el título como identificador único
    );

    return result.isNotEmpty;
  }
}

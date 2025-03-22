import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:vent_app/src/models/Article.dart';

const String tablePedidos = 'pedidos';
const String columnId = 'id';
const String columnSkuCode = 'sku_code';
const String columnEstatus = 'estatus';
const String columnIdUsuario = 'id_usuario';
const String columnPrecio = 'precio';
const String columnCantidad = 'cantidad';
const String columnDisponible = 'disponible';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Obtén la base de datos
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pedidos.db');
    return _database!;
  }

  // Inicializar la base de datos
  Future<Database> _initDB(String filePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, filePath);
    return openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Crear la tabla de pedidos
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
  }

  // Método para insertar un artículo usando los datos de la clase Article
  Future<int> insertArticleFromArticle(Article article) async {
    // Crear el mapa que la base de datos espera
    Map<String, dynamic> row = {
      columnSkuCode: article.skuCode,
      columnEstatus: article.estatus,
      columnIdUsuario: article.idUsuario,
      columnPrecio: article.precio,
      columnCantidad: article.cantidad,
      columnDisponible:
          article.disponible ? 1 : 0, // 1 para disponible, 0 para no disponible
    };

    // Usamos el método insertArticle para insertar en la base de datos
    return await insertArticle(row);
  }

  // Insertar un artículo
  Future<int> insertArticle(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(
      tablePedidos,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los artículos
  Future<List<Map<String, dynamic>>> getAllArticles() async {
    final db = await database;
    return await db.query(tablePedidos);
  }

  // Obtener el precio de un artículo por SKU
  Future<Object?> getArticlePrice(String sku) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT $columnPrecio FROM $tablePedidos WHERE $columnSkuCode = ?',
      [sku],
    );
    if (result.isNotEmpty) {
      return result.first[columnPrecio];
    } else {
      throw Exception('Artículo no encontrado');
    }
  }

  // Actualizar el precio de un artículo por SKU
  Future<int> updateArticlePrice(String sku, double newPrice) async {
    final db = await database;
    return await db.update(
      tablePedidos,
      {columnPrecio: newPrice},
      where: '$columnSkuCode = ?',
      whereArgs: [sku],
    );
  }

  // Actualizar la cantidad de un artículo por SKU
  Future<int> updateArticleQuantity(String sku, int newQuantity) async {
    final db = await database;
    return await db.update(
      tablePedidos,
      {columnCantidad: newQuantity},
      where: '$columnSkuCode = ?',
      whereArgs: [sku],
    );
  }

  // Eliminar un artículo por SKU
  Future<int> deleteArticle(String sku) async {
    final db = await database;
    return await db.delete(
      tablePedidos,
      where: '$columnSkuCode = ?',
      whereArgs: [sku],
    );
  }

  // Eliminar todos los artículos
  Future<int> deleteAllArticles() async {
    final db = await database;
    return await db.delete(tablePedidos);
  }
}

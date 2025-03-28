import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:vent_app/data/db/db_constants.dart';
import 'package:vent_app/src/models/Article.dart';
import 'database_helper.dart';
import '../models/pedido.dart';

class PedidosDAO {
  static final PedidosDAO _instance =
      PedidosDAO._internal(); // Instancia estática
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // StreamController para emitir los cambios en el contador
  final StreamController<int> _counterStreamController =
      StreamController<int>.broadcast();

  // Constructor privado
  PedidosDAO._internal() {
    _updateCounter(); // Actualiza el contador al instanciar
  }

  // Getter estático para obtener la instancia
  static PedidosDAO get instance => _instance;

  // Método para insertar un artículo desde un objeto Article
  Future<int> insertArticleFromArticle(Article article, int cant) async {
    Map<String, dynamic> row = {
      columnSkuCode: article.skuCode,
      columnEstatus: article.estatus,
      columnIdUsuario: article.idUsuario,
      columnPrecio: article.precio,
      columnCantidad: cant,
      columnDisponible: article.disponible ? 1 : 0,
    };

    // Llamar al método de inserción
    int id = await _insertArticle(row);

    // Actualizar el contador después de insertar
    _updateCounter();

    return id;
  }

  // Método interno para insertar o actualizar el artículo
  Future<int> _insertArticle(Map<String, dynamic> row) async {
    final db = await _dbHelper.database;

    // Verifica si el artículo ya existe por SKU
    final existingArticle = await db.query(
      tablePedidos,
      where: '$columnSkuCode = ?',
      whereArgs: [row[columnSkuCode]],
    );

    if (existingArticle.isNotEmpty) {
      // Si existe, actualizar la cantidad
      final existingQuantity =
          existingArticle.first[columnCantidad] as int? ?? 0;
      final newQuantity = existingQuantity + row[columnCantidad];

      return await db.update(
        tablePedidos,
        {columnCantidad: newQuantity},
        where: '$columnSkuCode = ?',
        whereArgs: [row[columnSkuCode]],
      );
    } else {
      // Si no existe, insertar nuevo artículo
      return await db.insert(
        tablePedidos,
        row,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Obtener todos los pedidos
  Future<List<Pedido>> getAllPedidos() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(tablePedidos);
    return maps.map((e) => Pedido.fromMap(e)).toList();
  }

  // Contar la cantidad total de pedidos
  Future<int> getTotalPedidosCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery(
      'SELECT SUM($columnCantidad) FROM $tablePedidos',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Actualizar el contador
  void _updateCounter() async {
    int count = await getTotalPedidosCount();
    _counterStreamController.add(count); // Emitir el nuevo contador
  }

  // Obtener el Stream para escuchar los cambios en el contador
  Stream<int> get counterStream => _counterStreamController.stream;

  // Eliminar un artículo
  Future<int> deletePedido(String sku) async {
    final db = await _dbHelper.database;
    int result = await db.delete(
      tablePedidos,
      where: '$columnSkuCode = ?',
      whereArgs: [sku],
    );

    // Actualizar el contador después de eliminar
    _updateCounter();
    return result;
  }

  // Eliminar todos los pedidos
  Future<int> deleteAllPedidos() async {
    final db = await _dbHelper.database;
    int result = await db.delete(tablePedidos);

    // Actualizar el contador después de eliminar todos
    _updateCounter();
    return result;
  }

  // Cerrar el StreamController cuando ya no sea necesario
  void dispose() {
    _counterStreamController.close();
  }
}

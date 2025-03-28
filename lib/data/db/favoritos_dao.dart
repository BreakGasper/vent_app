import 'package:sqflite/sqflite.dart';
import 'package:vent_app/data/db/db_constants.dart';
import 'database_helper.dart';
import '../models/favorito.dart';

class FavoritosDAO {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // Insertar un favorito
  Future<int> insertFavorito(Favorito favorito) async {
    final db = await _dbHelper.database;
    return await db.insert(
      tableFavoritos,
      favorito.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obtener todos los favoritos
  Future<List<Favorito>> getAllFavoritos() async {
    final db = await _dbHelper.database;
    final result = await db.query(tableFavoritos);
    return result.map((map) => Favorito.fromMap(map)).toList();
  }

  // Obtener un favorito por SKU
  Future<Favorito?> getFavoritoBySku(String sku) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      tableFavoritos,
      where: '$columnFavSkuCode = ?',
      whereArgs: [sku],
    );

    if (result.isNotEmpty) {
      return Favorito.fromMap(result.first);
    }
    return null;
  }

  // Actualizar el estado de favorito (toggle)
  Future<int> toggleFavorito(String sku, bool esFavorito) async {
    final db = await _dbHelper.database;
    return await db.update(
      tableFavoritos,
      {columnFavFavorito: esFavorito ? 1 : 0},
      where: '$columnFavSkuCode = ?',
      whereArgs: [sku],
    );
  }

  // Eliminar un favorito por SKU
  Future<int> deleteFavorito(String sku) async {
    final db = await _dbHelper.database;
    return await db.delete(
      tableFavoritos,
      where: '$columnFavSkuCode = ?',
      whereArgs: [sku],
    );
  }

  // Eliminar todos los favoritos
  Future<int> deleteAllFavoritos() async {
    final db = await _dbHelper.database;
    return await db.delete(tableFavoritos);
  }
}

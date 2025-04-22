import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:vent_app/src/models/Article.dart';

class FirebaseHelper {
  // Método para inicializar Firebase
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  static Stream<List<Article>> fetchArticles() {
    final DatabaseReference ref = FirebaseDatabase.instance.ref().child(
      'Categoria',
    );

    return ref.onValue.map((event) {
      final List<Article> loadedArticles = [];

      if (event.snapshot.value != null) {
        final categoriesData = event.snapshot.value as Map<dynamic, dynamic>;

        categoriesData.forEach((categoryKey, categoryValue) {
          final articlesData = categoryValue['articulos'];

          if (articlesData is List) {
            for (var articleMap in articlesData) {
              if (articleMap is Map) {
                Article article = Article.fromMap({
                  'id': articleMap['id'].toString(),
                  'sku_code': articleMap['sku_code'],
                  'status': articleMap['status'],
                  'id_usuario': articleMap['id_usuario'] ?? '',
                  'precio': articleMap['precio'],
                  'cantidad': articleMap['stock'],
                  'disponible':
                      articleMap['stock'] != null && articleMap['stock'] > 0,
                  'nombre': articleMap['nombre'],
                  'url': articleMap['url'],
                  'descripcion': articleMap['descripcion'] ?? '',
                  'proveedor': articleMap['proveedor'] ?? '',
                  'categoria': articleMap['categoria'] ?? '',
                  'unidadMedida': articleMap['unidadMedida'] ?? '',
                  'fechaRegistro': articleMap['fechaRegistro'] ?? '',
                  'caracteristicas': articleMap['caracteristicas'] ?? [],
                  'puntuacion': articleMap['puntuacion'] ?? 0.0,
                });

                loadedArticles.add(article);
              }
            }
          }
        });
      }
      return loadedArticles;
    });
  }

  Future<void> updateArticlesInFirebase() async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref().child(
      'Categoria',
    );

    try {
      // Obtén todos los datos de las categorías
      DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {
        final categoriesData = snapshot.value as Map<dynamic, dynamic>;

        print('Datos de categorías obtenidos: $categoriesData');

        for (var categoryKey in categoriesData.keys) {
          final categoryValue = categoriesData[categoryKey];
          final articlesData = categoryValue['articulos'];

          if (articlesData is List) {
            print(
              'Artículos encontrados en la categoría $categoryKey: $articlesData',
            );

            for (var articleMap in articlesData) {
              if (articleMap is Map) {
                // Asegúrate de que el 'id' sea un String
                String articleId =
                    articleMap['id'].toString(); // Convertir a String

                // Mostrar el artículo antes de actualizarlo
                print('Actualizando artículo con ID: $articleId');

                // Asignar puntuación por defecto (3.0) si no existe
                double puntuacion = 3.2;

                // Usar valor predeterminado para 'caracteristicas' si no está presente
                List<dynamic> caracteristicas =
                    articleMap['caracteristicas'] ??
                    ["Característica genérica 1", "Característica genérica 2"];

                print(
                  'Artículo ID: $articleId, puntuación: $puntuacion, características: $caracteristicas',
                );

                // Actualizar artículo en la base de datos
                DatabaseReference articleRef = ref
                    .child(categoryKey)
                    .child('articulos')
                    .child(articleId); // Asegúrate de que el id sea un String
                await articleRef.update({
                  'puntuacion': puntuacion,
                  'caracteristicas': caracteristicas,
                });

                print("Artículo $articleId actualizado.");
              }
            }
          }
        }
      } else {
        print("No se encontraron datos en la ruta Categoria.");
      }
    } catch (e) {
      print("Error al actualizar artículos: $e");
    }
  }

  static Stream<List<Article>> fetchArticlesByCategoria({
    String? categoryFilter,
  }) {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('Categoria');

    return ref.onValue.map((event) {
      List<Article> loadedArticles = [];

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> categoriesData =
            event.snapshot.value as Map<dynamic, dynamic>;

        categoriesData.forEach((categoryKey, categoryValue) {
          var articlesData = categoryValue['articulos'];

          if (articlesData is List) {
            for (var articleMap in articlesData) {
              if (articleMap is Map) {
                if (categoryFilter == null ||
                    articleMap['categoria'] == categoryFilter) {
                  Article article = Article.fromMap({
                    'id': articleMap['id'].toString(),
                    'sku_code': articleMap['sku_code'],
                    'status': articleMap['status'],
                    'id_usuario': articleMap['id_usuario'] ?? '',
                    'precio': articleMap['precio'],
                    'cantidad': articleMap['stock'],
                    'disponible':
                        articleMap['stock'] != null && articleMap['stock'] > 0,
                    'nombre': articleMap['nombre'],
                    'url': articleMap['url'],
                    'descripcion': articleMap['descripcion'] ?? '',
                    'proveedor': articleMap['proveedor'] ?? '',
                    'categoria': articleMap['categoria'] ?? '',
                    'unidadMedida': articleMap['unidadMedida'] ?? '',
                    'fechaRegistro': articleMap['fechaRegistro'] ?? '',
                  });

                  loadedArticles.add(article);
                }
              }
            }
          }
        });
      }

      return loadedArticles;
    });
  }
}

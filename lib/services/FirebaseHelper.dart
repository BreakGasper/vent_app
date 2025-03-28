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

  /*
  static Future<List<Article>> fetchArticles() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref().child(
        'Categoria',
      );
      DatabaseEvent event = await ref.once();
      List<Article> loadedArticles = [];

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> categoriesData =
            event.snapshot.value as Map<dynamic, dynamic>;

        categoriesData.forEach((categoryKey, categoryValue) {
          var articlesData = categoryValue['articulos'];

          // Verifica si articlesData es una lista
          if (articlesData is List) {
            for (var articleMap in articlesData) {
              // Verifica si el artículo es un Map válido
              if (articleMap is Map) {
                // Crear una instancia de Article usando los datos del artículo
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

                loadedArticles.add(article); // Añadir el artículo a la lista
              }
            }
          }
        });
      }
      return loadedArticles;
    } catch (e) {
      throw Exception("Error fetching articles: $e");
    }
  }
*/
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

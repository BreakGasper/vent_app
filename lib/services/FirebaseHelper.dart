import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseHelper {
  // Método para inicializar Firebase
  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  // Método para obtener los artículos de Firebase
  static Future<List<Map<String, String>>> fetchArticles() async {
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref().child(
        'Categoria',
      );
      DatabaseEvent event = await ref.once();
      List<Map<String, String>> loadedArticles = [];

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> categoriesData =
            event.snapshot.value as Map<dynamic, dynamic>;

        categoriesData.forEach((categoryKey, categoryValue) {
          var articlesData = categoryValue['articulos'];

          if (articlesData is List) {
            for (var value in articlesData) {
              String imageUrl =
                  'https://firebasestorage.googleapis.com/v0/b/mrapp-b8d1e.appspot.com/o/${value['url']}';
              loadedArticles.add({'title': value['nombre'], 'image': imageUrl});
            }
          }
        });
      }
      return loadedArticles;
    } catch (e) {
      throw Exception("Error fetching articles: $e");
    }
  }
}

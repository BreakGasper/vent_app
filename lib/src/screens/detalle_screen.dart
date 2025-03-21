import 'package:flutter/material.dart';
import 'package:vent_app/services/database_helper.dart'; // Asegúrate de tener esta importación

class DetalleScreen extends StatefulWidget {
  const DetalleScreen({super.key});

  @override
  State<DetalleScreen> createState() => _DetalleScreen();
}

class _DetalleScreen extends State<DetalleScreen> {
  List<Map<String, dynamic>> savedArticles =
      []; // Lista para almacenar los artículos de SQLite

  @override
  void initState() {
    super.initState();
    _loadArticlesFromDatabase();
  }

  // Método para cargar los artículos desde la base de datos
  Future<void> _loadArticlesFromDatabase() async {
    try {
      List<Map<String, dynamic>> articlesFromDb =
          await DatabaseHelper.instance.getArticles();
      setState(() {
        savedArticles =
            articlesFromDb
                .map((e) => {'title': e['title'], 'image': e['image']})
                .toList();
      });
    } catch (e) {
      debugPrint("Error al cargar artículos de la base de datos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Artículos Guardados')),
      body:
          savedArticles.isEmpty
              ? const Center(
                child: CircularProgressIndicator(),
              ) // Muestra un indicador de carga mientras obtienes los artículos
              : ListView.builder(
                itemCount: savedArticles.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.network(
                      savedArticles[index]['image']!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(savedArticles[index]['title']!),
                  );
                },
              ),
    );
  }
}

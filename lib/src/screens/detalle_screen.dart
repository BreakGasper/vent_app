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
          await DatabaseHelper.instance.getAllArticles();
      setState(() {
        savedArticles =
            articlesFromDb
                .map(
                  (e) => {'sku_code': e['sku_code'], 'estatus': e['estatus']},
                )
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
                    title: Text(savedArticles[index]['sku_code']!),
                  );
                },
              ),
    );
  }
}

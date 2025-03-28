import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vent_app/data/db/database_helper.dart';
import 'package:vent_app/data/db/pedidos_dao.dart';

import 'package:vent_app/src/models/Article.dart'; // Asegúrate de tener esta importación

class DetalleScreen extends StatefulWidget {
  final Article articulo; // Recibe un objeto Article en lugar de Pedido

  const DetalleScreen({super.key, required this.articulo});

  @override
  State<DetalleScreen> createState() => _DetalleScreen();
}

class _DetalleScreen extends State<DetalleScreen> {
  late Article articulo; // Aquí se guarda el artículo recibido

  @override
  void initState() {
    super.initState();
    articulo =
        widget
            .articulo; // Inicializamos el artículo con el que se pasa desde el constructor
  }

  // Método para agregar el artículo a los pedidos
  void onFabPressed(Article article) async {
    try {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Artículo agregado al pedido')));
    } catch (e) {
      debugPrint("Error al agregar artículo: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Artículo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: articulo.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 16),

            // Título del artículo
            Text(
              articulo.title, // Usamos la propiedad `title` de Article
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Descripción del artículo
            Text(
              articulo
                  .descripcion, // Usamos la propiedad `descripcion` de Article
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Precio del artículo
            Text(
              'Precio: \$${articulo.precio}',
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),

            const SizedBox(height: 8),

            // Mostrar la cantidad disponible
            Text(
              'Cantidad disponible: ${articulo.cantidad}',
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            // Botón para agregar al pedido
            ElevatedButton(
              onPressed: () {
                onFabPressed(articulo); // Agregar artículo al pedido
              },
              child: const Text('Agregar al Pedido'),
            ),
          ],
        ),
      ),
    );
  }
}

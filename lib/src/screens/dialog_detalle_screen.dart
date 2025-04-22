import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vent_app/data/db/database_helper.dart';
import 'package:vent_app/data/db/pedidos_dao.dart';

import 'package:vent_app/src/models/Article.dart';
import 'package:vent_app/src/resources/colors.dart'; // Asegúrate de tener esta importación

class DialogDetalleScreen extends StatefulWidget {
  final Article articulo; // Recibe un objeto Article en lugar de Pedido

  const DialogDetalleScreen({super.key, required this.articulo});

  @override
  State<DialogDetalleScreen> createState() => _DialogDetalleScreen();
}

class _DialogDetalleScreen extends State<DialogDetalleScreen> {
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
            Center(
              child: CachedNetworkImage(
                imageUrl: articulo.image,
                width: 170,
                height: 170,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            // Título del artículo
            Center(
              child: Text(
                articulo.title, // Usamos la propiedad `title` de Article
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Precio del artículo
            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween, // Distribuye los elementos en los extremos
              children: [
                Text(
                  'Precio: \$${articulo.precio}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.brightBlue,
                  ),
                ),
                Text(
                  'Disponible: ${articulo.cantidad}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.greenDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Botón para agregar al pedido
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                onPressed: () {
                  onFabPressed(articulo); // Agregar artículo al pedido
                },
                child: const Text(
                  'Agregar Pedido',
                  style: TextStyle(color: AppColors.lightGray),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

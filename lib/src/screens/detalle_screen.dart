import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vent_app/data/db/favoritos_dao.dart';
import 'package:vent_app/data/models/favorito.dart';
import 'package:vent_app/src/models/Article.dart';
import 'package:vent_app/src/resources/colors.dart';

class DetalleScreen extends StatefulWidget {
  final Article articulo;

  const DetalleScreen({super.key, required this.articulo});

  @override
  State<DetalleScreen> createState() => _DetalleScreen();
}

class _DetalleScreen extends State<DetalleScreen> {
  late Article articulo;
  bool isFavorite = false; // Variable para controlar el estado del favorito

  @override
  void initState() {
    super.initState();
    articulo = widget.articulo;
    checkIfFavorite(); // Verificar si el artículo está en favoritos
  }

  // Verificar si el SKU del artículo ya está en favoritos
  Future<void> checkIfFavorite() async {
    final favoritosDAO = FavoritosDAO(); // Crear una instancia de FavoritosDAO
    final favorito = await favoritosDAO.getFavoritoBySku(
      articulo.skuCode,
    ); // Buscar el artículo por su SKU

    if (favorito != null) {
      setState(() {
        isFavorite = true; // Si el favorito existe, marcarlo como true
      });
    }
  }

  Future<void> toggleFavorite() async {
    final favoritosDAO = FavoritosDAO(); // Crear una instancia de FavoritosDAO

    if (isFavorite) {
      // Si es favorito, eliminarlo de la base de datos
      await favoritosDAO.deleteFavorito(articulo.skuCode);
    } else {
      // Si no es favorito, agregarlo a la base de datos
      final nuevoFavorito = Favorito(
        skuCode: articulo.skuCode,
        nombre: articulo.title,
        descripcion: articulo.descripcion,
        precio: articulo.precio,
        stock: articulo.cantidad,
        url: articulo.image,
        unidadMedida: articulo.unidadMedida,
        proveedor: articulo.proveedor,
        fechaRegistro: DateTime.now().toString(),
        status: articulo.estatus,
        promocion: 0,
        almacen: articulo.almacen,
        categoria: articulo.categoria,
        favorito: true,
      );

      await favoritosDAO.insertFavorito(nuevoFavorito);
    }

    // Actualizar el estado después de agregar o eliminar
    setState(() {
      isFavorite = !isFavorite; // Cambiar el estado del favorito
    });

    // Mostrar un mensaje
    /*ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavorite
              ? 'Artículo agregado a favoritos'
              : 'Artículo eliminado de favoritos',
        ),
      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGray,
      body: Stack(
        children: [
          Column(
            children: [
              // Imagen del producto con esquinas curvas en la parte inferior
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(
                    50,
                  ), // Solo la esquina inferior izquierda
                ),
                child: CachedNetworkImage(
                  imageUrl: articulo.image,
                  width: double.infinity,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 16),

              // Contenedor blanco con los detalles
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppColors.lightGray,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Precio y disponibilidad alineados a los extremos
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '\$${articulo.precio}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 18,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${articulo.puntuacion}',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 3),
                      Text(
                        (articulo.cantidad > 0 || articulo.cantidad == -1)
                            ? articulo.cantidad == -1
                                ? 'Disponible 99+'
                                : 'Disponible ${articulo.cantidad.toString()}'
                            : 'No disponible', // Mostrar disponibilidad
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              (articulo.cantidad > 0 || articulo.cantidad == -1)
                                  ? Colors.green
                                  : Colors
                                      .red, // Cambiar color según disponibilidad
                        ),
                      ),
                      const SizedBox(height: 3),

                      // Título del artículo
                      Text(
                        articulo.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            // Descripción del artículo
                            const Text(
                              "Descripción del artículo",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              articulo.descripcion,
                              style: TextStyle(color: Colors.grey[600]),
                            ),

                            const SizedBox(height: 15),

                            // Características del artículo
                            const Text(
                              "Características",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              articulo.caracteristicas.isNotEmpty
                                  ? '- ${articulo.caracteristicas.join('\n- ')}' // Mostrar las características
                                  : "No hay características disponibles", // Mensaje si no hay características
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Botón de agregar al carrito
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Artículo agregado al pedido')),
                );
              },
              child: const Text(
                'Add to Cart',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),

          // Botón de "Favorito" flotante
          Positioned(
            top: 370,
            right: 30,
            child: FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Colors.white,
              onPressed: toggleFavorite, // Llamar a la función toggleFavorite
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color:
                    isFavorite
                        ? Colors.red
                        : Colors.red, // Cambiar el color según el estado
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:vent_app/src/models/Article.dart';
import 'package:vent_app/src/resources/colors.dart';
import 'package:vent_app/data/db/favoritos_dao.dart';
import 'package:vent_app/data/models/favorito.dart';

class ArticleCard extends StatefulWidget {
  final Article article;
  final int index;
  final VoidCallback onFabPressed;
  final VoidCallback onFabPlusClick;
  final VoidCallback onFabMinusClick;

  const ArticleCard({
    super.key,
    required this.article,
    required this.index,
    required this.onFabPressed,
    required this.onFabPlusClick,
    required this.onFabMinusClick,
  });

  @override
  _ArticleCardState createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  bool _showInput =
      false; // Controla si el input de cantidad y los botones '+' y '-' son visibles
  int _quantity = 1; // Cantidad inicial
  bool _isFavorite =
      false; // Esta variable determina si el corazón está relleno o no

  // Controlador para el TextField
  final TextEditingController _quantityController = TextEditingController();

  // Controlador de Favoritos
  final FavoritosDAO favoritosDAO = FavoritosDAO();

  // Función para actualizar la cantidad
  void _updateQuantity(int newQuantity) {
    setState(() {
      _quantity = newQuantity;
      _quantityController.text = _quantity.toString(); // Actualiza el TextField
    });
  }

  // Función para mostrar los botones de cantidad cuando se presiona el FAB original
  void _onFabPressed() {
    setState(() {
      _showInput = true; // Muestra los botones y el input
    });
    _updateQuantity(1);
    widget.onFabPressed();
  }

  // Función para incrementar la cantidad
  void _incrementQuantity() {
    _updateQuantity(_quantity + 1);
    widget.onFabPlusClick();
  }

  // Función para decrementar la cantidad
  void _decrementQuantity() {
    if (_quantity > 1) {
      _updateQuantity(_quantity - 1);
    }
    widget.onFabMinusClick();
  }

  // Función para manejar el estado del favorito (marcar o desmarcar)
  Future<void> _toggleFavorite() async {
    final favorito = await favoritosDAO.getFavoritoBySku(
      widget.article.skuCode,
    );

    if (favorito != null) {
      // Si ya está en favoritos, eliminarlo
      await favoritosDAO.deleteFavorito(widget.article.skuCode);
      setState(() {
        _isFavorite = false;
      });
    } else {
      // Si no está en favoritos, agregarlo
      final nuevoFavorito = Favorito(
        skuCode: widget.article.skuCode,
        nombre: widget.article.title,
        descripcion: widget.article.descripcion,
        precio: widget.article.precio,
        stock: widget.article.cantidad,
        url: widget.article.image,
        unidadMedida: widget.article.unidadMedida,
        proveedor: widget.article.proveedor,
        fechaRegistro: DateTime.now().toString(),
        status: widget.article.estatus,
        promocion: 0,
        almacen: widget.article.almacen,
        categoria: widget.article.categoria,
        favorito: true,
      );
      await favoritosDAO.insertFavorito(nuevoFavorito);
      setState(() {
        _isFavorite = true;
      });
    }
  }

  // Función para verificar si el artículo ya es favorito al iniciar
  Future<void> _checkFavoriteStatus() async {
    final favorito = await favoritosDAO.getFavoritoBySku(
      widget.article.skuCode,
    );
    setState(() {
      _isFavorite = favorito != null;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus(); // Verifica el estado de favorito cuando se inicializa
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: widget.article.image,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => const CircularProgressIndicator(),
                    errorWidget:
                        (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: _toggleFavorite, // Llama a la función de favoritos
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(
                        _isFavorite
                            ? Icons
                                .favorite // Corazón relleno
                            : Icons.favorite_border_outlined, // Corazón vacío
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.article.title,
              maxLines: 1,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              widget.article.descripcion,
              maxLines: 2,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              "\$${widget.article.precio}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (!_showInput)
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centra el contenido en la fila
                children: [
                  FloatingActionButton(
                    heroTag: 'article_card_fab_${UniqueKey()}',
                    onPressed: _onFabPressed,
                    shape: const CircleBorder(),
                    backgroundColor: AppColors.brightBlue,
                    mini: true,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ],
              )
            else
              SizedBox(
                width:
                    200, // Define un ancho máximo para los botones y el input
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceEvenly, // Distribuye mejor los widgets
                  children: [
                    FloatingActionButton(
                      heroTag: 'article_card_fab_${UniqueKey()}',
                      onPressed: _incrementQuantity,
                      backgroundColor: Colors.green,
                      shape: const CircleBorder(),
                      mini: true,
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                    SizedBox(
                      width: 50, // Reduce el tamaño del campo de texto
                      child: TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        inputFormatters: [
                          FilteringTextInputFormatter
                              .digitsOnly, // Solo permite números
                          LengthLimitingTextInputFormatter(
                            2,
                          ), // Limita a 2 caracteres
                        ],
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 10,
                          ),
                        ),
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {
                            _quantity = int.tryParse(value) ?? 1;
                          });
                        },
                      ),
                    ),
                    FloatingActionButton(
                      heroTag: 'article_card_fab_${UniqueKey()}',
                      onPressed: _decrementQuantity,
                      backgroundColor: Colors.red,
                      mini: true,
                      shape: const CircleBorder(),
                      child: Icon(
                        _quantity > 1
                            ? Icons.remove
                            : Icons
                                .delete, // Si es 1, muestra el icono de basura
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

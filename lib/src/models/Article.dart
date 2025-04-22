class Article {
  final String id;
  final String skuCode;
  final String estatus;
  final String idUsuario;
  final double precio;
  final int cantidad;
  final bool disponible;
  final String title;
  final String image;
  final String descripcion;
  final String proveedor;
  final String categoria;
  final String unidadMedida;
  final String fechaRegistro;
  final List<String> caracteristicas; // Cambiado a List<String>
  final String almacen; // Almacén del artículo
  final double cuponDescuento; // Descuento
  final bool inPromocion; // Si está en promoción
  final double puntuacion; // Puntuación del artículo
  Article({
    required this.id,
    required this.skuCode,
    required this.estatus,
    required this.idUsuario,
    required this.precio,
    required this.cantidad,
    required this.disponible,
    required this.title,
    required this.image,
    required this.descripcion,
    required this.proveedor,
    required this.categoria,
    required this.unidadMedida,
    required this.fechaRegistro,
    required this.caracteristicas, // Usar una lista de características
    required this.almacen, // Almacén
    required this.cuponDescuento, // Cupón de descuento
    required this.inPromocion, // Indicador de promoción
    required this.puntuacion, // Puntuación del artículo
  });

  // Método para convertir un mapa de datos a una instancia de Article
  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      id: map['id'],
      skuCode: map['sku_code'],
      estatus: map['status'],
      idUsuario: map['id_usuario'] ?? '',
      precio:
          map['precio'] is int
              ? (map['precio'] as int).toDouble()
              : map['precio'].toDouble(),
      cantidad: map['cantidad'] ?? 0,
      disponible: map['stock'] != null && map['stock'] > 0,
      title: map['nombre'],
      image:
          'https://firebasestorage.googleapis.com/v0/b/mrapp-b8d1e.appspot.com/o/${map['url']}',
      descripcion: map['descripcion'] ?? '',
      proveedor: map['proveedor'] ?? '',
      categoria: map['categoria'] ?? '',
      unidadMedida: map['unidadMedida'] ?? '',
      fechaRegistro: map['fechaRegistro'] ?? '',
      // Convertir las características a una lista de Strings
      caracteristicas: List<String>.from(map['caracteristicas'] ?? []),
      almacen: map['almacen'] ?? '', // Almacén
      cuponDescuento: map['cuponDescuento'] ?? 0.0, // Cupón de descuento
      inPromocion: map['inPromocion'] ?? false, // Si está en promoción
      puntuacion: map['puntuacion'] ?? 0.0, // Puntuación del artículo
    );
  }

  // Método para convertir una instancia de Article a un mapa de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sku_code': skuCode,
      'status': estatus,
      'id_usuario': idUsuario,
      'precio': precio,
      'cantidad': cantidad,
      'stock': disponible ? 1 : 0,
      'nombre': title,
      'url': image,
      'descripcion': descripcion,
      'proveedor': proveedor,
      'categoria': categoria,
      'unidadMedida': unidadMedida,
      'fechaRegistro': fechaRegistro,
      'caracteristicas': caracteristicas, // Guardar como lista
      'almacen': almacen, // Almacén
      'cuponDescuento': cuponDescuento, // Cupón de descuento
      'inPromocion': inPromocion, // Indicador de promoción
      'puntuacion': puntuacion, // Puntuación del artículo
    };
  }
}

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
    );
  }
}

class Favorito {
  final int? id;
  final String skuCode;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;
  final String url;
  final String unidadMedida;
  final String proveedor;
  final String fechaRegistro;
  final String status;
  final int promocion;
  final String almacen;
  final String categoria;
  final bool favorito;

  Favorito({
    this.id,
    required this.skuCode,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
    required this.url,
    required this.unidadMedida,
    required this.proveedor,
    required this.fechaRegistro,
    required this.status,
    required this.promocion,
    required this.almacen,
    required this.categoria,
    required this.favorito,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sku_code': skuCode,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'stock': stock,
      'url': url,
      'unidadMedida': unidadMedida,
      'proveedor': proveedor,
      'fechaRegistro': fechaRegistro,
      'status': status,
      'promocion': promocion,
      'almacen': almacen,
      'categoria': categoria,
      'favorito': favorito ? 1 : 0,
    };
  }

  factory Favorito.fromMap(Map<String, dynamic> map) {
    return Favorito(
      id: map['id'],
      skuCode: map['sku_code'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      precio: map['precio'],
      stock: map['stock'],
      url: map['url'],
      unidadMedida: map['unidadMedida'],
      proveedor: map['proveedor'],
      fechaRegistro: map['fechaRegistro'],
      status: map['status'],
      promocion: map['promocion'],
      almacen: map['almacen'],
      categoria: map['categoria'],
      favorito: map['favorito'] == 1,
    );
  }
}

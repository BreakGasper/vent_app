class Pedido {
  final int? id;
  final String skuCode;
  final String estatus;
  final String idUsuario;
  final double precio;
  final int cantidad;
  final bool disponible;

  Pedido({
    this.id,
    required this.skuCode,
    required this.estatus,
    required this.idUsuario,
    required this.precio,
    required this.cantidad,
    required this.disponible,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sku_code': skuCode,
      'estatus': estatus,
      'id_usuario': idUsuario,
      'precio': precio,
      'cantidad': cantidad,
      'disponible': disponible ? 1 : 0,
    };
  }

  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      id: map['id'],
      skuCode: map['sku_code'],
      estatus: map['estatus'],
      idUsuario: map['id_usuario'],
      precio: map['precio'],
      cantidad: map['cantidad'],
      disponible: map['disponible'] == 1,
    );
  }
}

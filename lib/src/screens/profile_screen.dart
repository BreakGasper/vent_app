import 'package:flutter/material.dart';
import 'package:vent_app/data/db/database_helper.dart';
import 'package:vent_app/data/db/pedidos_dao.dart';
import 'package:vent_app/data/models/pedido.dart'; // Asegúrate de tener esta importación

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  List<Map<String, dynamic>> savedArticles =
      []; // Lista para almacenar los artículos de SQLite

  @override
  void initState() {
    super.initState();
    _loadPedidosFromDatabase();
  }

  // Método para cargar los artículos desde la base de datos
  // Método para cargar los pedidos desde la base de datos
  Future<void> _loadPedidosFromDatabase() async {
    try {
      PedidosDAO pedidosDAO = PedidosDAO.instance; // Crear una nueva instancia
      List<Pedido> pedidosFromDb = await pedidosDAO.getAllPedidos();

      setState(() {
        savedArticles =
            pedidosFromDb
                .map(
                  (pedido) => {
                    'sku_code': pedido.skuCode,
                    'cantidad': pedido.cantidad,
                    'estatus': pedido.estatus,
                    'precio': pedido.precio,
                    'id_usuario': pedido.idUsuario,
                    'disponible': pedido.disponible ? 1 : 0,
                  },
                )
                .toList();
      });
    } catch (e) {
      debugPrint("Error al cargar pedidos de la base de datos: $e");
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

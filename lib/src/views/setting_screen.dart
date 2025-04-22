import 'package:flutter/material.dart';
import 'package:vent_app/src/resources/colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: AppColors.darkBlue,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: AppColors.lightGray),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Abre el drawer manualmente
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.darkBlue),
              child: const Text(
                'Menú',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add_box),
              title: const Text('Nuevo producto'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar a pantalla de nuevo producto
              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Contactos'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar a contactos
              },
            ),
            ListTile(
              leading: const Icon(Icons.request_quote),
              title: const Text('Cotizaciones'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navegar a cotizaciones
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              selected: true, // Esta pantalla está activa
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Ayuda'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Mostrar ayuda
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Opciones de configuración aquí',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

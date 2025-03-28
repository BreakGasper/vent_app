import 'package:flutter/material.dart';
import 'package:vent_app/data/db/pedidos_dao.dart';
import 'package:vent_app/src/resources/colors.dart';
import 'package:vent_app/src/screens/detalle_screen.dart';
import 'package:vent_app/src/screens/home_screen.dart';
import 'package:vent_app/data/db/database_helper.dart';
import 'package:vent_app/src/screens/profile_screen.dart';

class MainInitScreen extends StatefulWidget {
  const MainInitScreen({super.key});

  @override
  State<MainInitScreen> createState() => _MainInitScreen();
}

class _MainInitScreen extends State<MainInitScreen> {
  int _selectedIndex = 0;
  bool _isMenuOpen = false;
  final int _counter = 0; // Contador para mostrar en el círculo rojo

  // Lista de widgets para mostrar según el índice
  final List<Widget> _screens = [
    const HomeScreen(), // Pantalla principal
    ProfileScreen(), // Detalle de usuario
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VentApps',
          style: TextStyle(color: AppColors.lightGray),
        ),
        backgroundColor: AppColors.darkBlue,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: _selectedIndex == 0 ? 'VentApps' : '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label: _selectedIndex == 1 ? 'Yo' : '',
              ),
            ],
            currentIndex: _selectedIndex,
            backgroundColor: AppColors.darkBlue,
            selectedItemColor: AppColors.lightGray,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
          ),
          Positioned(
            bottom: 22,
            child: Stack(
              clipBehavior: Clip.none, // Permite que el contador sobresalga
              children: [
                FloatingActionButton(
                  heroTag: 'design_main_fab_${UniqueKey()}',
                  onPressed: _toggleMenu,
                  backgroundColor: AppColors.lightGray,
                  shape: CircleBorder(),
                  child: Icon(
                    _isMenuOpen ? Icons.close : Icons.shopping_cart,
                    color: AppColors.brightBlue,
                  ),
                ),
                // El círculo pequeño rojo con el contador
                Positioned(
                  top: -5, // Ajusta la posición del contador encima del FAB
                  right: -5, // Ajusta la posición horizontal del contador
                  child: StreamBuilder<int>(
                    stream:
                        PedidosDAO
                            .instance
                            .counterStream, // Usa la instancia estática de PedidosDAO
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Muestra un indicador de carga mientras no haya datos
                      }

                      // Si no hay datos, asignamos el valor predeterminado (0)
                      int counter = snapshot.data ?? 0;

                      return Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.red, // Color rojo para el contador
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$counter',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Método que genera un FloatingActionButton con animación
  Widget _buildMenuItem(IconData icon, double x, double y) {
    return GestureDetector(
      onTap: () {
        debugPrint('Clicked $icon');
        // Puedes añadir la lógica aquí cuando se haga clic en un ícono del menú
      },
      child: FloatingActionButton(
        heroTag: 'article_card_fab_${UniqueKey()}',
        mini: true,
        onPressed: () {
          debugPrint('Clicked $icon');
        },
        backgroundColor: AppColors.brightBlue,
        child: Icon(icon, color: AppColors.lightGray),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vent_app/src/resources/colors.dart';
import 'package:vent_app/src/screens/detalle_screen.dart';
import 'package:vent_app/src/screens/home_screen.dart';

class MainInitScreen extends StatefulWidget {
  const MainInitScreen({super.key});

  @override
  State<MainInitScreen> createState() => _MainInitScreen();
}

class _MainInitScreen extends State<MainInitScreen> {
  int _selectedIndex = 0;
  bool _isMenuOpen = false;
  int _counter = 0; // Contador para mostrar en el círculo rojo

  // Lista de widgets para mostrar según el índice
  final List<Widget> _screens = [
    const HomeScreen(), // Pantalla principal
    DetalleScreen(), // Detalle de usuario
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
                  child: Container(
                    width: 20, // Tamaño del círculo
                    height: 20, // Tamaño del círculo
                    decoration: BoxDecoration(
                      color: Colors.red, // Color rojo para el contador
                      shape: BoxShape.circle, // Forma circular
                    ),
                    child: Center(
                      child: Text(
                        '$_counter', // Muestra el contador
                        style: const TextStyle(
                          color: Colors.white, // Texto blanco
                          fontSize: 12, // Tamaño de la fuente
                        ),
                      ),
                    ),
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

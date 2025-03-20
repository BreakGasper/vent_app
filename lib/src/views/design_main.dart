import 'package:flutter/material.dart';
import 'package:vent_app/src/resources/colors.dart';
import 'package:vent_app/src/screens/detalle_screen.dart';
import 'package:vent_app/src/screens/home_screen.dart';

class MainInitScreen extends StatefulWidget {
  const MainInitScreen({super.key});

  @override
  State<MainInitScreen> createState() => _MainInitScreen();
}

class _MainInitScreen extends State<MainInitScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isMenuOpen = false;

  // Lista de widgets para mostrar según el índice
  final List<Widget> _screens = [
    const HomeScreen(), // Pantalla principal
    DetalleScreen(), // Puedes agregar aquí una pantalla de perfil más adelante
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
      body: Stack(
        children: [
          // Mostrar la pantalla correspondiente al índice seleccionado
          _screens[_selectedIndex],
          // Menú radial
          if (_isMenuOpen) ...[
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 150,
                  left: 60,
                ), // Ajustado
                child: _buildMenuItem(Icons.search, 60, 150),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 150), // Ajustado
                child: _buildMenuItem(Icons.add, 0, 110),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 150,
                  right: 60,
                ), // Ajustado
                child: _buildMenuItem(Icons.settings, -60, 150),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              // Home
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label:
                    _selectedIndex == 0
                        ? 'VentApps'
                        : '', // Texto solo cuando está seleccionado
              ),
              // Profile
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                label:
                    _selectedIndex == 1
                        ? 'Yo'
                        : '', // Texto solo cuando está seleccionado
              ),
            ],
            currentIndex: _selectedIndex,
            backgroundColor: AppColors.darkBlue,
            selectedItemColor: AppColors.lightGray,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
            // No es necesario el selectedLabelStyle aquí
          ),
          Positioned(
            bottom: 22,
            child: FloatingActionButton(
              onPressed: _toggleMenu,
              backgroundColor: AppColors.lightGray,
              shape: CircleBorder(),
              child: Icon(
                _isMenuOpen ? Icons.close : Icons.catching_pokemon_rounded,
                color: AppColors.brightBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, double x, double y) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: _isMenuOpen ? 1.0 : 0.0,
      child: Transform.translate(
        offset: Offset(x, y),
        child: FloatingActionButton(
          mini: true,
          onPressed: () => print('Clicked $icon'),
          backgroundColor: AppColors.brightBlue,
          child: Icon(icon, color: AppColors.lightGray),
        ),
      ),
    );
  }
}

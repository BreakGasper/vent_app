import 'package:flutter/material.dart';

class DetalleScreen extends StatefulWidget {
  const DetalleScreen({super.key});

  @override
  State<DetalleScreen> createState() => _DetalleScreen();
}

class _DetalleScreen extends State<DetalleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text('DetalleScreen')));
  }
}

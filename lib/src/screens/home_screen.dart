import 'package:flutter/material.dart';
import 'package:vent_app/src/resources/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  // Lista de artículos con título y url de imagen
  final List<Map<String, String>> articles = [
    {
      'title': 'Artículo 1',
      'image': 'https://picsum.photos/200', // Imagen de ejemplo
    },
    {'title': 'Artículo 2', 'image': 'https://picsum.photos/200'},
    {'title': 'Artículo 3', 'image': 'https://picsum.photos/200'},
    {'title': 'Artículo 4', 'image': 'https://picsum.photos/200'},
    {'title': 'Artículo 5', 'image': 'https://picsum.photos/200'},
    {'title': 'Artículo 6', 'image': 'https://picsum.photos/200'},
  ];

  // Mapa para saber si el FAB fue presionado para un artículo
  final Map<int, bool> isFabPressed = {};

  // Mapa para almacenar el valor de cada artículo
  final Map<int, int> articleCount = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        color: AppColors.lightGray,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Grid de artículos, dos por fila
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Número de artículos por fila
                  crossAxisSpacing: 10.0, // Espaciado entre columnas
                  mainAxisSpacing: 10.0, // Espaciado entre filas
                  childAspectRatio: 0.7, // Relación de aspecto de cada celda
                ),
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Imagen del artículo
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            articles[index]['image']!,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Título del artículo
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            articles[index]['title']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // Si se ha presionado el FAB, mostrar el TextField y botones
                        if (isFabPressed[index] == true)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icono de Plus en forma circular
                                Container(
                                  height: 30, // Contenedor de tamaño 30
                                  width: 30, // Contenedor de tamaño 30
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: AppColors.lightGray,
                                        size:
                                            18, // Ajustamos el tamaño del ícono
                                      ),
                                      padding:
                                          EdgeInsets
                                              .zero, // Elimina el padding por defecto
                                      onPressed: () {
                                        setState(() {
                                          // Incrementar el valor
                                          articleCount[index] =
                                              (articleCount[index] ?? 0) + 1;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                // TextField para mostrar y editar el valor
                                SizedBox(
                                  width: 50,
                                  child: TextField(
                                    controller: TextEditingController(
                                      text:
                                          (articleCount[index] ?? 0).toString(),
                                    ),
                                    readOnly:
                                        true, // Solo lectura, para evitar que se edite directamente
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 5),
                                // Icono de Minus en forma circular
                                Container(
                                  height: 30, // Contenedor de tamaño 30
                                  width: 30, // Contenedor de tamaño 30
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.remove,
                                        color: AppColors.lightGray,
                                        size:
                                            18, // Ajustamos el tamaño del ícono
                                      ),
                                      padding:
                                          EdgeInsets
                                              .zero, // Elimina el padding por defecto
                                      onPressed: () {
                                        setState(() {
                                          // Disminuir el valor, asegurándose de no ser menor que 0
                                          if ((articleCount[index] ?? 0) > 0) {
                                            articleCount[index] =
                                                (articleCount[index] ?? 0) - 1;
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // Botón de añadir, ocultado si ya fue presionado
                        if (isFabPressed[index] != true)
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: FloatingActionButton(
                              shape: CircleBorder(),
                              mini: true,
                              onPressed: () {
                                setState(() {
                                  // Cambiar el estado de este artículo para que se oculte el FAB y se muestren los botones
                                  isFabPressed[index] = true;
                                });
                                print(
                                  "Añadir artículo ${articles[index]['title']}",
                                );
                              },
                              backgroundColor: AppColors.brightBlue,
                              child: Icon(
                                Icons.add,
                                color: AppColors.lightGray,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

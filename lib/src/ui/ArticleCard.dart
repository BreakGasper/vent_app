import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vent_app/src/resources/colors.dart';

class ArticleCard extends StatelessWidget {
  final Map<String, String> article;
  final int index;
  final VoidCallback onFabPressed; // Callback para el FAB

  const ArticleCard({
    Key? key,
    required this.article,
    required this.index,
    required this.onFabPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: article['image']!,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              article['title']!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // Agregar el FAB dentro de cada tarjeta de artículo
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: FloatingActionButton(
              onPressed:
                  onFabPressed, // Llamamos al callback para actualizar los artículos
              backgroundColor: AppColors.brightBlue,
              child: Icon(Icons.add, color: AppColors.lightGray),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:vent_app/src/models/Article.dart';
import 'package:vent_app/src/resources/colors.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final int index;
  final VoidCallback onFabPressed;

  const ArticleCard({
    super.key,
    required this.article,
    required this.index,
    required this.onFabPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: article.image,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => const CircularProgressIndicator(),
                    errorWidget:
                        (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.favorite, color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              article.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              article.descripcion,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${article.precio}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FloatingActionButton(
                  onPressed: onFabPressed,
                  backgroundColor: AppColors.brightBlue,
                  mini: true,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

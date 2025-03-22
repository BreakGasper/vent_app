import 'package:flutter/material.dart';
import 'package:vent_app/services/FirebaseHelper.dart';
import 'package:vent_app/services/database_helper.dart';
import 'package:vent_app/src/models/Article.dart';
import 'package:vent_app/src/resources/colors.dart';
import 'package:vent_app/src/ui/ArticleCard.dart';
import 'package:vent_app/src/ui/ArticleItems.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  List<Article> articles = [];
  bool isFirebaseInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    try {
      await FirebaseHelper.initializeFirebase();
      setState(() {
        isFirebaseInitialized = true;
      });
      _fetchArticles();
    } catch (e) {
      debugPrint("Error al inicializar Firebase: \$e");
    }
  }

  void _fetchArticles() async {
    try {
      List<Article> loadedArticles = await FirebaseHelper.fetchArticles();
      setState(() {
        articles = loadedArticles;
      });
    } catch (e) {
      debugPrint("Error fetching articles: \$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        color: AppColors.lightGray,
        child:
            isFirebaseInitialized
                ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Artículos",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 400,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: articles.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 200),
                                  child: ArticleCard(
                                    article: articles[index],
                                    index: index,
                                    onFabPressed: () {
                                      onFabPressed(articles[index]);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            "Más Artículos",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 10.0,
                              ),
                              child: ArticleItems(
                                article: articles[index],
                                index: index,
                                onPressed: () {
                                  onFabPressed(articles[index]);
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  void onFabPressed(Article article) async {
    try {
      int id = await DatabaseHelper.instance.insertArticleFromArticle(article);
      debugPrint("Artículo insertado con ID: \$id");
    } catch (e) {
      debugPrint("Error al insertar el artículo: \$e");
    }
  }
}

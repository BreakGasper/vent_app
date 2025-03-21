import 'package:flutter/material.dart';
import 'package:vent_app/services/FirebaseHelper.dart';
import 'package:vent_app/src/resources/colors.dart';
import 'package:vent_app/src/ui/ArticleCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  List<Map<String, String>> articles = [];
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
      debugPrint("Error al inicializar Firebase: $e");
    }
  }

  void _fetchArticles() async {
    try {
      List<Map<String, String>> loadedArticles =
          await FirebaseHelper.fetchArticles();
      setState(() {
        articles = loadedArticles;
      });
    } catch (e) {
      debugPrint("Error fetching articles: $e");
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
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: articles.length,
                        itemBuilder: (context, index) {
                          return ArticleCard(
                            article: articles[index],
                            index: index,
                            onFabPressed: () {
                              debugPrint('FAB pressed');
                            },
                          );
                        },
                      ),
                    ),
                  ],
                )
                : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

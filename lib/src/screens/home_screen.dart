import 'package:flutter/material.dart';
import 'package:vent_app/data/db/pedidos_dao.dart';
import 'package:vent_app/services/FirebaseHelper.dart';
import 'package:vent_app/data/db/database_helper.dart';
import 'package:vent_app/src/models/Article.dart';
import 'package:vent_app/src/resources/colors.dart';
import 'package:vent_app/src/screens/detalle_screen.dart';
import 'package:vent_app/src/ui/ArticleCard.dart';
import 'package:vent_app/src/ui/ArticleItems.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  List<Article> articles = [];
  List<Article> articlesbyCategoria = [];
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
      // _fetchArticles();
      // _fetchArticlesbyCategoria();
    } catch (e) {
      debugPrint("Error al inicializar Firebase: $e");
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
                            "Novedades",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 400,
                          child: _fetchArticlesByCategory(),
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
                        _fetchArticles(),
                        _buildTotalArticlesCount(), // Mostrar el total de artículos
                      ],
                    ),
                  ),
                )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  // Método para escuchar y mostrar el contador de artículos en tiempo real
  Widget _buildTotalArticlesCount() {
    return StreamBuilder<int>(
      stream:
          PedidosDAO.instance.counterStream, // Escucha el Stream de PedidosDAO
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error al cargar contador: ${snapshot.error}'),
          );
        }

        int totalCount = snapshot.data ?? 0; // Si no hay datos, mostrar 0
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            "Total Pedidos: $totalCount",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }

  StreamBuilder<List<Article>> _fetchArticles() {
    return StreamBuilder<List<Article>>(
      stream: FirebaseHelper.fetchArticles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error al cargar artículos: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay artículos disponibles.'));
        }

        final articles = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
                  _showDetalleDialog(context, articles[index]);
                  // Navega a la pantalla de detalles
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DetalleScreen(articulo: articles[index]),
                    ),
                  );*/
                },
              ),
            );
          },
        );
      },
    );
  }

  void _showDetalleDialog(BuildContext context, Article articulo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: SizedBox(
            width: 350, // Ajusta el ancho deseado
            height: 500, // Ajusta la altura deseada
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: DetalleScreen(articulo: articulo),
            ),
          ),
        );
      },
    );
  }

  StreamBuilder<List<Article>> _fetchArticlesByCategory() {
    return StreamBuilder<List<Article>>(
      stream: FirebaseHelper.fetchArticlesByCategoria(
        categoryFilter: "Novedades",
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No hay artículos disponibles.');
        }

        final articlesbyCategoria = snapshot.data!;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: articlesbyCategoria.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 200),
                child: ArticleCard(
                  article: articlesbyCategoria[index],
                  index: index,
                  onFabPressed: () {
                    onFabPressed(articlesbyCategoria[index], 1);
                  },
                  onFabPlusClick: () {
                    onFabPressed(articlesbyCategoria[index], 1);
                  },
                  onFabMinusClick: () {
                    onFabPressed(articlesbyCategoria[index], -1);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  void onFabPressed(Article article, int cant) async {
    try {
      PedidosDAO pedidosDAO = PedidosDAO.instance;

      // Inserta el pedido en la base de datos utilizando la clase PedidosDAO
      int id = await pedidosDAO.insertArticleFromArticle(article, cant);
      debugPrint("Pedido insertado con ID: $id");
    } catch (e) {
      debugPrint("Error al insertar el pedido: $e");
    }
  }
}

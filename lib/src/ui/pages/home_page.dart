import 'package:flutter/material.dart';
import 'package:pr_10/src/models/game_model.dart';
import 'package:pr_10/src/resources/api.dart';
import 'package:pr_10/src/ui/components/game_card.dart';
import 'package:pr_10/src/ui/pages/add_page.dart';
import 'package:pr_10/src/ui/pages/info_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Game>> _games;

  @override
  void initState() {
    super.initState();
    _games = ApiService().getProducts();
  }
  void _addGame(Game game) {
    setState(() {
      ApiService().addProduct(game);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Машины',
            style: TextStyle(
              color: Color.fromRGBO(76, 23, 0, 1.0),
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
          future: _games,
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 20.0,
                    left: 20.0,
                  ),
                  child: Text(
                    'Нет доступных товаров, добавьте хотя бы одну карточку',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(76, 23, 0, 1.0),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            final games = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 15.0,

              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  childAspectRatio: 161 / 205,
                ),
                itemCount: games.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => InfoPage(gameId: games[index].id),
                        ),
                      );
                      if (result != null && result is Game) {
                        setState(() {
                          games[index] = result;
                        });
                      }
                      else if(result != null && result is int){
                        setState(() {
                          // _removeGame(result);
                        });
                      }
                    },
                    child: GameCard(
                      game: games[index],
                      bodyColor: games[index].colorInd == 1 ? const Color.fromRGBO(255, 207, 2, 1.0) : games[index].colorInd == 2 ? const Color.fromRGBO(163, 3, 99, 1.0) : const Color.fromRGBO(48, 0, 155, 1.0),
                      textColor: games[index].colorInd == 1 ? const Color.fromRGBO(129, 40, 0, 1.0) : games[index].colorInd == 2 ? const Color.fromRGBO(255, 204, 254, 1.0) : const Color.fromRGBO(203, 238, 251, 1.0),
                    ),
                  );
                },
              ),
            );

          }
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: SizedBox(
          width: 50,
          height: 50,
          child: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPage()),
              );
              if (result != null && result is Game) {
                _addGame(result);
              }
            },
            backgroundColor: const Color.fromRGBO(76, 23, 0, 1.0),
            foregroundColor: const Color.fromRGBO(255, 230, 230, 1.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(45),
            ),
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

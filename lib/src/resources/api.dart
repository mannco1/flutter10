import 'package:dio/dio.dart';
import 'package:pr_10/src/models/basket_model.dart';
import 'package:pr_10/src/models/favorite_model.dart';
import 'package:pr_10/src/models/game_model.dart';
import 'package:pr_10/src/models/user_model.dart';

class ApiService {
  final Dio _dio = Dio();
// Метод для получения списка всех товаров
  Future<List<Game>> getProducts() async {
    try {
      final response = await _dio.get('http://10.0.2.2:8080/products');
      if (response.statusCode == 200) {
        List<Game> games = (response.data as List)
            .map((game) => Game.fromJson(game))
            .toList();

        return games;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
// Метод для получения товара по ID
  Future<Game> getProductById(int gameId) async {
    try {
      final response = await _dio.get('http://10.0.2.2:8080/products/$gameId');
      if (response.statusCode == 200) {
        return Game.fromJson(response.data);
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }

  // Метод для добавления нового товара
  Future<void> addProduct(Game item) async {
    try {
      final response = await _dio.post(
        'http://10.0.2.2:8080/products',
        data: item.toJson(),
      );
      print(item.toJson().toString());
      if (response.statusCode == 201) {
        print('Product added successfully');
      } else {
        throw Exception('Failed to add product');
      }
    } catch (e) {
      throw Exception('Error adding product: $e');
    }
  }

  // Удаление товара
  Future<void> deleteProduct(int id) async {
    try {
      final response = await _dio.delete(
        'http://10.0.2.2:8080/products/$id',
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to delete item');
      }
    } catch (e) {
      throw Exception('Error deleting item: $e');
    }
  }

  // Обновление информации о продукте
  Future<void> updateGameInfo(int id, Game item) async {
    try {
      final response = await _dio.put(
        'http://10.0.2.2:8080/products/$id',
        data: item.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to update information');
      }
    } catch (e) {
      throw Exception('Error updating information: $e');
    }
  }
// Получение данных пользователя
  Future<User> getUser() async {
    try {
      final response = await _dio.get('http://10.0.2.2:8080/user/1');

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
// Получение элементов в корзине
  Future<List<BasketItem>> getBasket() async {
    try {
      final response = await _dio.get('http://10.0.2.2:8080/cart/1');
      if (response.statusCode == 200) {
        print("Basket Response: ${response.data}");
        List<BasketItem> basket = (response.data as List)
            .map((item) => BasketItem.fromJson(item))
            .toList();

        return basket;
      } else {
        throw Exception('Failed to load basket');
      }
    } catch (e) {
      throw Exception('Error fetching basket: $e');
    }
  }

  // Добавление товара в корзину
  Future<void> addToBasket(int gameId, int counter) async {
    await _dio.post('http://10.0.2.2:8080/cart/1', data: {"product_id": gameId, "quantity": counter});
  }
  // Удаление товара из корзины
  Future<void> removeFromBasket(int gameId) async {
    await _dio.delete('http://10.0.2.2:8080/cart/1/$gameId');
  }

  // Получение избранных игр пользователя
  Future<List<Favorite>> getFavorites() async {
    try {
      final response = await _dio.get('http://10.0.2.2:8080/favorites/1');
      if (response.statusCode == 200) {
        print("Basket Response: ${response.data}");
        List<Favorite> favorites = (response.data as List)
            .map((item) => Favorite.fromJson(item))
            .toList();

        return favorites;
      } else {
        throw Exception('Failed to load basket');
      }
    } catch (e) {
      throw Exception('Error fetching basket: $e');
    }
  }
  // Добавление игры в "Избранное"
  Future<void> addToFavorites(int gameId) async {
    await _dio.post('http://10.0.2.2:8080/favorites/1', data: {"product_id": gameId});
  }
  // Удаление игры из "Избранного"
  Future<void> removeFromFavorites(int gameId) async {
    await _dio.delete('http://10.0.2.2:8080/favorites/1/$gameId');
  }


}
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/product.dart';
import 'package:http/http.dart' as http;
import 'package:shop/utils/constants.dart';

class ProductList with ChangeNotifier {
  final String _token;
  final String _userId;
  List<Product> _items = [];

  List<Product> get items => [..._items]; // Os ... significam 'clonar' a lista
  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  int get itemsCount {
    return _items.length;
  }

  //Método para carregar os produtos do Firebase
  Future<void> loadProducts() async {
    _items.clear();
    final response = await http.get(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'),
    );
    if (response.body == 'null') return;

    final favResponse = await http.get(
      Uri.parse(
        '${Constants.USER_FAVORITES_URL}/$_userId.json?auth=$_token',
      ),
    );

    Map<String, dynamic> favData =
        favResponse.body == 'null' ? {} : json.decode(favResponse.body);

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((productId, productData) {
      final isFavorite = favData[productId] ?? false;
      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: (productData['price'] as num).toDouble(),
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
        ),
      );
    });
    notifyListeners();
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'),
        body: jsonEncode(
          {
            "name": product.name,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      //Primeiro exclui o produto localmente
      _items.remove(product);
      notifyListeners();

      //Depois exclui ele no servidor
      final response = await http.delete(
        Uri.parse(
            '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'),
      );

      //Se der erro no servidor, o produto é inserido de volta
      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
      }
    }
  }

  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'),
      body: jsonEncode(
        {
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        },
      ),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(
      Product(
          id: id,
          name: product.name,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl),
    );

    notifyListeners();
  }
}


// bool _showFavoriteOnly = false;

//   List<Product> get items {
//     //Se o valor for verdadeiro, mostra a lista filtrada
//     if (_showFavoriteOnly == true) {
//       return _items.where((product) => product.isFavorite).toList();
//     }
//     //Senão mostra a lista com todos os itens
//     return [..._items]; // Os ... significam 'clonar' a lista
//   }

//   void showFavoriteOnly() {
//     _showFavoriteOnly = true;
//     notifyListeners();
//   }

//   void showAll() {
//     _showFavoriteOnly = false;
//     notifyListeners();
//   }
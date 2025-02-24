import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';
import 'package:http/http.dart' as http;

class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts;
  final _baseUrl = 'https://shop-jaciel-default-rtdb.firebaseio.com';

  List<Product> get items => [..._items]; // Os ... significam 'clonar' a lista
  List<Product> get favoriteItems =>
      _items.where((product) => product.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  void saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['imageUrl'] as String,
    );

    if (hasId) {
      updateProduct(product);
    } else {
      addProduct(product);
    }
  }

  void updateProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }
  }

  void addProduct(Product product) {
    http.post(
      Uri.parse('$_baseUrl/products.json'),
      body: jsonEncode(
        {
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
        },
      ),
    );

    _items.add(product);
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
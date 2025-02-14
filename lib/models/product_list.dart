import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get items => [..._items]; // Os ... significam 'clonar' a lista
  List<Product> get favoriteItems => _items.where((product) => product.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  void addProduct(Product product) {
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
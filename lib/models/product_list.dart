import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class ProductList with ChangeNotifier {
  List<Product> _items = dummyProducts;

  List<Product> get items => [..._items]; // Os ... significam 'clonar' a lista

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}

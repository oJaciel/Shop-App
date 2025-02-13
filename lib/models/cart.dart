import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/product.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    //Se já tiver esse produto no carrinho, atualiza o carrinho, só adicionando mais um na quantidade
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
            id: existingItem.id,
            productId: existingItem.productId,
            name: existingItem.name,
            quantity: existingItem.quantity + 1,
            price: existingItem.price),
      );
    } else {
      //Senão, adiciona um novo item
      _items.putIfAbsent(
          product.id,
          () => CartItem(
              id: Random().nextDouble().toString(),
              productId: product.id,
              name: product.name,
              quantity: 1,
              price: product.price));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  //Remover um único item
  //Usado na snackbar
  void removeSingleItem(String productId) {
    //Se a lista de produtos ainda não tem esse item, passa
    if (_items.containsKey(productId) == false) {
      return;
    }
    //Se já tem o item, mas a quantidade é só 1, remove totalmente o item do carrinho
    if (_items[productId]?.quantity == 1) {
      _items.remove(productId);
    } else {
      //Senão, caso a quantidade seja maior que 1, subtrai 1 da quantidade total
      _items.update(
        productId,
        (existingItem) => CartItem(
            id: existingItem.id,
            productId: existingItem.productId,
            name: existingItem.name,
            quantity: existingItem.quantity - 1,
            price: existingItem.price),
      );
    }
    notifyListeners();
  }

  //Limpar lista
  void clear() {
    _items = {};
    notifyListeners();
  }
}

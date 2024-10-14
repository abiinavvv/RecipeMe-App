import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingListItem {
  final String name;
  int quantity;

  ShoppingListItem({required this.name, this.quantity = 1});

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
  };

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) => ShoppingListItem(
    name: json['name'],
    quantity: json['quantity'],
  );
}

class ShoppingListProvider with ChangeNotifier {
  List<ShoppingListItem> _items = [];
  
  List<ShoppingListItem> get items => _items;

  ShoppingListProvider() {
    _loadFromPrefs();
  }

  void addIngredient(String ingredient) {
    final existingItem = _items.firstWhere(
      (item) => item.name == ingredient,
      orElse: () => ShoppingListItem(name: ingredient),
    );

    if (_items.contains(existingItem)) {
      existingItem.quantity++;
    } else {
      _items.add(existingItem);
    }
    notifyListeners();
    _saveToPrefs();
  }

  void removeIngredient(String ingredient) {
    _items.removeWhere((item) => item.name == ingredient);
    notifyListeners();
    _saveToPrefs();
  }

  void updateQuantity(String ingredient, int quantity) {
    final item = _items.firstWhere((item) => item.name == ingredient);
    item.quantity = quantity;
    notifyListeners();
    _saveToPrefs();
  }

  void clearList() {
    _items.clear();
    notifyListeners();
    _saveToPrefs();
  }

  void _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(_items.map((item) => item.toJson()).toList());
    await prefs.setString('shopping_list', encodedData);
  }

  void _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('shopping_list');
    if (encodedData != null) {
      final List<dynamic> decodedData = json.decode(encodedData);
      _items = decodedData.map((item) => ShoppingListItem.fromJson(item)).toList();
      notifyListeners();
    }
  }

  bool isInList(String ingredient) {
    return _items.any((item) => item.name == ingredient);
  }

  int getQuantity(String ingredient) {
    final item = _items.firstWhere(
      (item) => item.name == ingredient,
      orElse: () => ShoppingListItem(name: ingredient, quantity: 0),
    );
    return item.quantity;
  }

  void addRecipe(List<String> ingredients) {
    for (final ingredient in ingredients) {
      addIngredient(ingredient);
    }
  }

  void removeRecipe(List<String> ingredients) {
    for (final ingredient in ingredients) {
      final item = _items.firstWhere(
        (item) => item.name == ingredient,
        orElse: () => ShoppingListItem(name: ingredient, quantity: 0),
      );
      if (item.quantity > 1) {
        item.quantity--;
      } else {
        _items.remove(item);
      }
    }
    notifyListeners();
    _saveToPrefs();
  }
}
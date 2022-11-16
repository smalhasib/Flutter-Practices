import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../provider/Cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _items = [];
  late String authToken;
  late String userId;

  List<OrderItem> get items {
    return [..._items];
  }

  void update(String token, String id) {
    authToken = token;
    userId = id;
  }

  Future<void> fetchOrders() async {
    final url = Uri.https(
      'shop-app-41f1b-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/orders/$userId.json',
      {'auth': authToken},
    );
    final response = await http.get(url);
    List<OrderItem> loadedOrders = [];
    final Map<String, dynamic>? data = json.decode(response.body);
    if (data == null) return;
    data.forEach((key, value) {
      loadedOrders.add(
        OrderItem(
          id: key,
          amount: value['amount'],
          products: (value['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  quantity: item['quantity'],
                  price: item['price'],
                ),
              )
              .toList(),
          dateTime: DateTime.parse(value['dateTime']),
        ),
      );
    });
    _items = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https(
      'shop-app-41f1b-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/orders/$userId.json',
      {'auth': authToken},
    );
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    _items.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      ),
    );
    notifyListeners();
  }
}

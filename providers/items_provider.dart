import 'package:final_project/models/item.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';

class ItemsProvider with ChangeNotifier {
  String idToken;

  List<Item> _items = [];

  List<Item> getSecionItems(String sectionId) {
    print('section id is $sectionId');
    _items.forEach((element) {
      print(element.sectionId);
    });
    return _items.where((element) => element.sectionId == sectionId).toList();
  }

  List<Item> getShopItems(String shopId) {
    return _items.where((element) => element.shopId == shopId).toList();
  }

  List<Item> getitem(String id) {
    return _items.where((element) => element.id == id).toList();
  }

  Future<void> addItem(Item i) async {
    try {
      var res = await http.post(
        'https://w-y-w-a2a1e-default-rtdb.firebaseio.com/items.json?auth=$idToken',
        body: json.encode(
          {
            'sectionId': i.sectionId,
            'shopId': i.shopId,
            'sectionName': i.sectionName,
            'shopName': i.shopName,
            'name': i.name,
            'price': i.price,
            'speacalPrice': i.speacalPrice,
            'descrption': i.descrption,
            'imageUrl': i.imageUrl,
          },
        ),
      );
      var resBody = json.decode(res.body) as Map<String, dynamic>;

      var firebaseId = resBody['name'];
      i.id = firebaseId;
      _items.add(i);
      print('Firebase id is : ${i.id}');
      notifyListeners();
    } catch (err) {
      print(err.toString());
      print('error in add to server');

      throw (err);
    }
  }

  List<Item> get item {
    return [..._items];
  }

  Future<void> getItemsFromServer() async {
    try {
      final url =
          'https://w-y-w-a2a1e-default-rtdb.firebaseio.com/items.json?auth=$idToken';
      var res = await http.get(url);
      var jsonResult = json.decode(res.body) as Map<String, dynamic>;
      List<Item> tempList = [];
      jsonResult.forEach((key, value) {
        Item tempItem = Item(
          id: key,
          shopId: value['shopId'] as String,
          sectionId: value['sectionId'] as String,
          sectionName: value['sectionName'] as String,
          speacalPrice: value['speacalPrice'] as double,
          shopName: value['shopName'] as String,
          name: value['name'] as String,
          imageUrl: value['imageUrl'] as String,
          price: value['price'] as double,
          descrption: value['descrption'] as String,
        );
        tempList.add(tempItem);
      });
      _items = tempList;
      print('shops in provider length is ${_items.length}');
      notifyListeners();
    } catch (err) {
      print(err.toString());
      print('error ing get from server');
      throw (err);
    }
  }

  // Future<void> getItemsFromServer() async {
  //   try {
  //     var res = await http.get(
  //         'https://w-y-w-a2a1e-default-rtdb.firebaseio.com/items.json?auth=$idToken');
  //     var itemsMap = json.decode(res.body) as Map<String, dynamic>;
  //     var newItems = List<Item>();
  //     itemsMap.forEach((key, v) {
  //       var value = v as Map<String, dynamic>;
  //       print(key);
  //       print(value);
  //       var i = Item(
  //         id: key,
  //         shopId: value['shopId'] as String,
  //         sectionId: value['sectionId'] as String,
  //         sectionName: value['sectionName'] as String,
  //         speacalPrice: value['speacalPrice'] as double,
  //         shopName: value['shopName'] as String,
  //         name: value['name'] as String,
  //         imageUrl: value['imageUrl'] as String,
  //         price: value['price'] as double,
  //         descrption: value['descrption'] as String,
  //       );
  //       newItems.add(i);
  //     });
  //     _items = newItems;
  //     notifyListeners();
  //   } catch (err) {
  //     print(err.toString());
  //     throw (err);
  //   }
  // }

  void refreshItems(List<Item> newItems) {
    _items = newItems;
    notifyListeners();
  }

  Future<void> editItem(Item i) async {
    try {
      var res = await http.patch(
        'https://w-y-w-a2a1e-default-rtdb.firebaseio.com/items/${i.id}.json?auth=$idToken',
        body: json.encode(
          {
            'shopId': i.shopId,
            'sectionId': i.sectionId,
            'shopName': i.shopName,
            'sectionName': i.sectionName,
            'name': i.name,
            'price': i.price,
            'speacalPrice': i.speacalPrice,
            'descrption': i.descrption,
          },
        ),
      );

      _items.removeWhere((element) => element.id == i.id);
      _items.add(i);
      notifyListeners();
    } catch (error) {
      print(error.message);
      throw error;
    }
  }

  List<Item> getSectionItemsById(String sectionId) {
    return _items.where((element) => element.sectionId == sectionId).toList();
  }
}

import 'package:final_project/models/shop.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ShopProvider with ChangeNotifier {
  String idToken;
  List<Shop> _shops = [];

  Future<void> addShop(Shop s) async {
    final url =
        'https://w-y-w-a2a1e-default-rtdb.firebaseio.com/shops.json?auth=$idToken';
    //?auth=$idToken
    var res = await http.post(
      url,
      body: json.encode(
        {
          'name': s.name,
          'area': s.area,
          'email': s.email,
          // 'latitude': s.latitude,
          // 'longitued': s.longitued,
          'phoneNumber': s.phoneNumber,
          'logoUrl': s.logoUrl,
        },
      ),
    );
    var fireBaseResult = json.decode(res.body) as Map<String, dynamic>;
    s.id = fireBaseResult['name'];
    _shops.add(s);
    notifyListeners();
  }

  Future<void> editShop(Shop s) async {
    final url =
        'https://w-y-w-a2a1e-default-rtdb.firebaseio.com/shops/${s.id}.json?auth=$idToken';
    await http.patch(
      url,
      body: json.encode(
        {
          'name': s.name,
          'area': s.area,
          'email': s.email,
          // 'latitude': s.latitude,
          // 'longitued': s.longitued,
          'phoneNumber': s.phoneNumber,
          'logoUrl': s.logoUrl
        },
      ),
    );
    _shops.removeWhere((element) => element.id == s.id);
    _shops.add(s);
    notifyListeners();
  }

  List<Shop> get shops {
    return [..._shops];
  }

  Future<void> getShops() async {
    final url =
        'https://w-y-w-a2a1e-default-rtdb.firebaseio.com/shops.json?auth=$idToken';
    try {
      var res = await http.get(url);
      var resJson = json.decode(res.body) as Map<String, dynamic>;
      List<Shop> tempShops = [];
      resJson.forEach(
        (key, value) {
          Shop tempShop = Shop(
            id: key,
            name: value['name'],
            area: value['area'],
            email: value['email'],
            phoneNumber: value['phoneNumber'],
            logoUrl: value['logoUrl'],
          );
          tempShops.add(tempShop);
        },
      );

      _shops = tempShops;
      notifyListeners();
    } catch (error) {
      throw Exception('couldn\'t load shops');
    }
  }

  Shop getShopById(String shopId) {
    return _shops.firstWhere((element) => element.id == shopId, orElse: null);
  }
}

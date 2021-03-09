import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/Section.dart';

class SectionProvider with ChangeNotifier {
  String idToken;
  List<Section> _sections = [];
  List<Section> get section {
    return [..._sections];
  }

  List<Section> getSectionsByShopId(String shopId) {
    return _sections.where((element) {
      return shopId == element.shopId;
    }).toList();
  }

  Section getSectionById(String sectionId) {
    return _sections.firstWhere((element) => element.id == sectionId,
        orElse: () => null);
  }

  Future<void> editSection(Section s) async {
    final url =
        'https://w-y-w-a2a1e-default-rtdb.firebaseio.com/section/${s.id}.json?auth=$idToken';
    try {
      await http.patch(
        url,
        body: json.encode(
          {
            'shopId': s.shopId,
            'name': s.name,
          },
        ),
      );

      _sections.removeWhere((old) {
        return old.id == s.id;
      });

      _sections.add(s);
      notifyListeners();
    } catch (error) {}
  }

  Future<void> addSection(Section s) async {
    final url =
        'https://w-y-w-a2a1e-default-rtdb.firebaseio.com/section.json?auth=$idToken';
    try {
      var res = await http.post(
        url,
        body: json.encode(
          {
            'shopId': s.shopId,
            'name': s.name,
          },
        ),
      );
      var jsonResult = json.decode(res.body) as Map<String, dynamic>;
      s.id = jsonResult['name'];
      _sections.add(s);
      notifyListeners();
    } catch (error) {}
  }

  Future<void> getSections() async {
    final url =
        'https://w-y-w-a2a1e-default-rtdb.firebaseio.com/section.json?auth=$idToken';
    try {
      var res = await http.get(url);
      var jsonResult = json.decode(res.body) as Map<String, dynamic>;
      List<Section> tempSections = [];
      jsonResult.forEach((key, value) {
        tempSections.add(Section(
          id: key,
          shopId: value['shopId'],
          name: value['name'],
          image: value['image'],
        ));
      });
      _sections = tempSections;
      notifyListeners();
    } catch (error) {}
  }
}

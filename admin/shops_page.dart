import 'package:final_project/admin/Section_page.dart';
import 'package:final_project/admin/authentication_page.dart';
import 'package:final_project/providers/authentication_provider.dart';
import 'package:final_project/providers/shops_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_shop_page.dart';

class ShopsPage extends StatefulWidget {
  static const namedRoute = "/shops_page";

  @override
  _ShopsPageState createState() => _ShopsPageState();
}

class _ShopsPageState extends State<ShopsPage> {
  bool gotInit = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getShops();
  }

  void getShops() async {
    if (!gotInit) {
      try {
        await Provider.of<ShopProvider>(context).getShops();
        gotInit = true;
      } catch (err) {
        showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Error'),
                content: Text(err.toString()),
                actions: [
                  FlatButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text('ok'))
                ],
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var shops = Provider.of<ShopProvider>(context).shops;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.red[200],
        title: Text('Shops'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AddShopPage.namedRoute, arguments: {
                'isEditing': false,
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              var prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.of(context)
                  .pushReplacementNamed(AuthenticationPage.namedRoute);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: shops.length,
        itemBuilder: (_, i) {
          return Card(
              child: new Column(children: <Widget>[
            ListTile(
              //   leading: new Image.asset(
              //     shops[i].logoUrl,
              //     fit: BoxFit.cover,
              //     width: 100.0,
              //   ),
              title: new Text(
                shops[i].name,
                style:
                    new TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
              ),
              subtitle: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(shops[i].area,
                        style: new TextStyle(
                            fontSize: 13.0, fontWeight: FontWeight.normal)),
                  ]),
              onTap: () {
                Navigator.of(context)
                    .pushNamed(SectionsPage.namedRoute, arguments: shops[i].id);
              },
              trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AddShopPage.namedRoute, arguments: {
                      'isEditing': true,
                      'shop': shops[i],
                    });
                  }),
            )
          ]));
        },
      ),
    );
  }
}

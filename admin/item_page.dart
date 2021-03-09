import 'package:final_project/admin/Section_page.dart';
import 'package:final_project/admin/add_items_page.dart';
import 'package:final_project/providers/authentication_provider.dart';
import 'package:final_project/providers/items_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication_page.dart';

class ItemPage extends StatefulWidget {
  static const namedRoute = '/items_page';

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  bool gotInit = false;
  @override
  Future itemFuture;
  @override
  void initState() {
    super.initState();
    itemFuture =
        Provider.of<ItemsProvider>(context, listen: false).getItemsFromServer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      if (!gotInit) {
        getDataFromServer();
      }
    } catch (err) {}
  }

  void getDataFromServer() async {
    try {
      var sectionId = ModalRoute.of(context).settings.arguments as String;

      var items = Provider.of<ItemsProvider>(context).getSecionItems(sectionId);
      gotInit = true;
    } catch (err) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Something went wrong'),
            content: Text(err.toString()),
            actions: [
              RaisedButton(
                child: Text('Back'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var sectionId = ModalRoute.of(context).settings.arguments as String;
    var item =
        Provider.of<ItemsProvider>(context).getSectionItemsById(sectionId);
    print(item.length);
    return Scaffold(
      appBar: AppBar(
        title: Text('Items'),
        backgroundColor: Colors.red[200],
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AddItemPage.namedRoute, arguments: {
                'isAdding': true,
                'item': item,
                'sectionId': sectionId,
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
      body: FutureBuilder(
        future: itemFuture,
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapShot.error != null) {
              //handle the error here
              return Center(child: Text('something went wrong'));
            } else {
              return Consumer<ItemsProvider>(
                builder: (context, value, child) {
                  return ListView.builder(
                    itemCount: item.length,
                    itemBuilder: (_, i) {
                      return ListTile(
                        onTap: () {
                          // Navigator.of(context).pushNamed(
                          //     SectionsPage.namedRoute,
                          //     arguments: item[i].id);
                        },
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(item[i].imageUrl),
                        ),
                        title: Text(item[i].name),
                        // trailing: IconButton(
                        //   icon: Icon(Icons.add),
                        //   onPressed: () {
                        //     Navigator.of(context)
                        //         .pushNamed(AddItemPage.namedRoute, arguments: {
                        //       'isAdding': true,
                        //       'item': value.item[i],
                        //       'sectionId': sectionId,
                        //     });
                        //   },
                        // ),
                      );
                    },
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}

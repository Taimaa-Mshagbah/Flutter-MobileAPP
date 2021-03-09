import 'package:final_project/admin/authentication_page.dart';
import 'package:final_project/providers/authentication_provider.dart';
import 'package:final_project/providers/items_provider.dart';
import 'package:final_project/user/items_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowItemPage extends StatefulWidget {
  static const namedRoute = '/show_items_page';

  @override
  _ShowItemPageState createState() => _ShowItemPageState();
}

class _ShowItemPageState extends State<ShowItemPage> {
  bool gotInit = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!gotInit) {
      getDataFromServer();
    }
  }

  void getDataFromServer() async {
    try {
      await Provider.of<ItemsProvider>(context).getItemsFromServer();
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

    var items = Provider.of<ItemsProvider>(context).getSecionItems(sectionId);
    //print(items.length);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        title: Text('What You Want'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigator.of(context)
              //     .pushNamed(AddShopPage.namedRoute, arguments: {
              //   'isEditing': false,
              // });
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
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: items.length,
        itemBuilder: (_, i) {
          return Card(
            child: ListTile(
              trailing: Text(items[i].sectionName),
              onTap: () {
                Navigator.of(context).pushNamed(ItemDetailsPage.namedRoute,
                    arguments: items[i].id);
              },
              title: Text(
                items[i].name,
              ),
            ),
          );
        },
      ),
    );
  }
}

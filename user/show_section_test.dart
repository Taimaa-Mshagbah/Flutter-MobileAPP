import 'package:final_project/admin/authentication_page.dart';
import 'package:final_project/admin/item_page.dart';
import 'package:final_project/pages/test.dart';
import 'dart:math';

import 'package:final_project/providers/Sections_provider.dart';
import 'package:final_project/providers/authentication_provider.dart';
import 'package:final_project/providers/items_provider.dart';
import 'package:final_project/user/items_details_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowItemPageTest extends StatefulWidget {
  static const namedRoute = '/show_items_page_test';

  @override
  _ShowItemPageTestState createState() => _ShowItemPageTestState();
}

class _ShowItemPageTestState extends State<ShowItemPageTest>
    with TickerProviderStateMixin {
  bool gotInit = false;
  var COLORS = [
    Color(0xFFEF7A85),
    Color(0xFFFF90B3),
    Color(0xFFFFC2E2),
    Color(0xFFB892FF),
    Color(0xFFB892FF)
  ];

  int i;

  @override
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
    String sectionId = ModalRoute.of(context).settings.arguments as String;

    var item =
        Provider.of<ItemsProvider>(context).getSectionItemsById(sectionId);
    print(item.length);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        title: Text('What she wants'),
        actions: [
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
//         body: GridView.builder(
//           gridDelegate:
//               SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
//           itemCount: item.length,
//           itemBuilder: (_, i) {
//             return GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pushNamed(ItemDetailsPage.namedRoute,
//                     arguments: item[i].id);
//               },
//               child: Card(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//                   child: Text(
//                     item[i].name,
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ));
//   }
// }
      body: Stack(
        children: <Widget>[
          new Transform.translate(
            offset:
                new Offset(0.0, MediaQuery.of(context).size.height * 0.1050),
            child: new ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0.0),
              scrollDirection: Axis.vertical,
              primary: true,
              itemCount: item.length,
              itemBuilder: (BuildContext content, int i) {
                return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                          ItemDetailsPage.namedRoute,
                          arguments: item[i].id);
                    },
                    child: AwesomeListItem(
                        title: item[i].name,
                        content: item[i].descrption,
                        // color: item[i].color,
                        image: item[i].imageUrl));
              },
            ),
          ),
          new Transform.translate(
            offset: Offset(0.0, -56.0),
            child: new Container(
              child: new ClipPath(
                clipper: new MyClipper(),
                child: new Stack(
                  children: [
                    new Image.network(
                      "https://picsum.photos/800/400?random",
                      fit: BoxFit.cover,
                    ),
                    new Opacity(
                      opacity: 0.2,
                      child: new Container(color: COLORS[0]),
                    ),
                    new Transform.translate(
                      offset: Offset(0.0, 50.0),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height / 4.75);
    p.lineTo(0.0, size.height / 3.75);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

class AwesomeListItem extends StatefulWidget {
  String title;
  String content;
  String color;
  String image;

  AwesomeListItem({this.title, this.content, this.color, this.image});

  @override
  _AwesomeListItemState createState() => new _AwesomeListItemState();
}

var COLORS = [
  Color(0xFFEF7A85),
  Color(0xFFFF90B3),
  Color(0xFFFFC2E2),
  Color(0xFFB892FF),
  Color(0xFFB892FF)
];

class _AwesomeListItemState extends State<AwesomeListItem> {
  @override
  Widget build(BuildContext context) {
    //var items = ModalRoute.of(context).settings.arguments as String;

    var item = Provider.of<ItemsProvider>(context).item;
    return new Row(
      children: <Widget>[
        new Container(
          width: 10.0,
          height: 190,
          color: COLORS[new Random().nextInt(5)],
        ),
        new Expanded(
          child: new Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 40.0,
              horizontal: 20.0,
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  widget.title,
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: new Text(
                    widget.content,
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
        new Container(
          height: 150.0,
          width: 150.0,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              new Transform.translate(
                offset: new Offset(50.0, 0.0),
                child: new Container(
                  height: 100.0,
                  width: 100.0,
                  color: COLORS[new Random().nextInt(5)],
                ),
              ),
              new Transform.translate(
                offset: Offset(10.0, 20.0),
                child: new Card(
                  elevation: 20.0,
                  child: new Container(
                    height: 120.0,
                    width: 120.0,
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                            width: 10.0,
                            color: Colors.white,
                            style: BorderStyle.solid),
                        image: DecorationImage(
                          image: NetworkImage(widget.image),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:final_project/admin/authentication_page.dart';
import 'package:final_project/providers/authentication_provider.dart';
import 'package:final_project/providers/items_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemDetailsPage extends StatefulWidget {
  static const namedRoute = '/details_items_page';

  @override
  _ItemDetailsPageState createState() => _ItemDetailsPageState();
}

class _ItemDetailsPageState extends State<ItemDetailsPage>
    with TickerProviderStateMixin {
  bool gotInit = false;
  @override
  AnimationController animationController;
  Animation<double> bottomAnimation;
  AnimationController animationController2;
  Animation<double> bottomAnimation2;

  bool _isBig = false;
  void initState() {
    // TODO: implement initState
    super.initState();

    animationController = AnimationController(
      //  vsync: this,
      duration: Duration(seconds: 3),
      vsync: this,
    );

    bottomAnimation = Tween<double>(begin: -100.0, end: 300.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceInOut,
      ),
    );
    animationController.addListener(() {
      setState(() {});
    });
    animationController2 = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    bottomAnimation2 = Tween<double>(begin: -100.0, end: 200.0).animate(
      CurvedAnimation(
        parent: animationController2,
        curve: Curves.bounceInOut,
      ),
    );
    animationController2.addListener(() {
      setState(() {});
    });
    animationController.forward().then((value) {
      animationController.reverse();
      animationController2.forward();
    });
  }

  void goBigOrSmall() {
    setState(() {
      _isBig = !_isBig;
    });
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
    String id = ModalRoute.of(context).settings.arguments as String;

    var items = Provider.of<ItemsProvider>(context).getitem(id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        title: Text("Your item details"),
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
      body: Stack(children: [
        Card(
            child: PageView.builder(
                itemCount: items.length,
                itemBuilder: (_, i) {
                  return GestureDetector(
                    child: Card(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(items[i].imageUrl),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                        child: Text(
                          items[i].name,
                          style: TextStyle(
                              color: Colors.red[200],
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  );
                })),
        Positioned(
            bottom: bottomAnimation2.value,
            child: Container(
              width: 300,
              child: RaisedButton(
                color: Colors.red[200],
                onPressed: () {
                  goBigOrSmall();
                },
                child: Text("your item"),
              ),
            )),
      ]),
    );
    // Positioned(
    //   bottom: bottomAnimation2.value,
    //   child: Container(
    //     width: 300,
    //     child: RaisedButton(
    //       color: Colors.blue,
    //       onPressed: () {
    //         goBigOrSmall();
    //       },
    //       child: Text('Size up and down'),
    //     ),
    //   ),
    // ),
  }
}

// Card(
//           child: ListView.builder(
//             itemCount: items.length,
//             itemBuilder: (_, i) {
//               return ListTile(
//                 trailing: Text(items[i].descrption),
//                 title: Text(
//                   items[i].name,
//                 ),
//               );
//             },
//           ),

//         )

//         );
//   }
// }

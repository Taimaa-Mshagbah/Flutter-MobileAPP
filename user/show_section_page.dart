import 'package:final_project/admin/authentication_page.dart';
import 'package:final_project/admin/item_page.dart';

import 'package:final_project/providers/Sections_provider.dart';
import 'package:final_project/providers/authentication_provider.dart';
import 'package:final_project/user/show_items.dart';
import 'package:final_project/user/show_section_test.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowSectionsPage extends StatefulWidget {
  static const namedRoute = '/show_sections_page';

  @override
  _ShowSectionsPageState createState() => _ShowSectionsPageState();
}

int selectedIndex = 0;

class _ShowSectionsPageState extends State<ShowSectionsPage> {
  bool gotInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!gotInit) {
      getSectionFromServer();
    }
  }

  void getSectionFromServer() async {
    await Provider.of<SectionProvider>(context).getSections();
    gotInit = true;
  }

  @override
  Widget build(BuildContext context) {
    var section = Provider.of<SectionProvider>(context).section;

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
        body: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: section.length,
          itemBuilder: (_, i) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ShowItemPageTest.namedRoute,
                    arguments: section[i].id);
              },
              child: Card(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(section[i].image),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  child: Text(
                    section[i].name,
                    style: TextStyle(
                        color: Colors.red[200],
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
//                 elevation: 10,
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
//                   child: Text(
//                     section[i].name,
//                     style: TextStyle(fontSize: 18),
//                   ),
//                 ),
// //                child: ClipRRect(
// //   borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
// //   child: Image.network(section.image),
// // )
//               ),
            );
          },
        ));
  }
}

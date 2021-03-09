import 'package:final_project/admin/add_section_page.dart';
import 'package:final_project/admin/authentication_page.dart';
import 'package:final_project/admin/item_page.dart';
import 'package:final_project/providers/Sections_provider.dart';
import 'package:final_project/providers/authentication_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SectionsPage extends StatefulWidget {
  static const namedRoute = '/sections_page';

  @override
  _SectionsPageState createState() => _SectionsPageState();
}

class _SectionsPageState extends State<SectionsPage> {
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
    String shopId = ModalRoute.of(context).settings.arguments as String;
    var sections = Provider.of<SectionProvider>(context).section;
    print(sections.length);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        title: Text('Sections'),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.add),
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(
          //       AddSectionPage.namedRoute,
          //       arguments: {
          //         'isEditing': false,
          //         'shopId': shopId,
          //       },
          //     );
          //   },
          // ),
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
        itemCount: sections.length,
        itemBuilder: (_, i) {
          return ListTile(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ItemPage.namedRoute, arguments: sections[i].id);
            },
            title: Text(sections[i].name),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AddSectionPage.namedRoute, arguments: {
                  'isEditing': true,
                  'shopId': sections[i].shopId,
                  'section': sections[i],
                });
              },
            ),
          );
        },
      ),
    );
  }
}

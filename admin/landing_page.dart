//import 'package:final_project/Widget/dropdown_list.dart';
import 'package:final_project/admin/authentication_page.dart';
import 'package:final_project/providers/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  static const namedRoute = '/landing_page';
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () async {
                await Provider.of<AuthenticationProvider>(context,
                        listen: false)
                    .logoutUser();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AuthenticationPage.namedRoute, (_) {
                  return false;
                });
              },
              child: Text('Logout'),
            )
          ]),
    );
  }
}

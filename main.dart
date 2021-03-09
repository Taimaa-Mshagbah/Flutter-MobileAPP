import 'package:final_project/admin/Section_page.dart';
import 'package:final_project/admin/add_items_page.dart';
import 'package:final_project/admin/add_section_page.dart';
import 'package:final_project/admin/add_shop_page.dart';
import 'package:final_project/admin/item_page.dart';
import 'package:final_project/admin/landing_page.dart';
import 'package:final_project/admin/shops_page.dart';
import 'package:final_project/admin/authentication_page.dart';
import 'package:final_project/pages/chooseWereToLogin.dart';
import 'package:final_project/pages/test.dart';

import 'package:final_project/providers/Sections_provider.dart';
import 'package:final_project/providers/authentication_provider.dart';
import 'package:final_project/providers/items_provider.dart';
import 'package:final_project/providers/shops_provider.dart';

import 'package:final_project/user/authntiction_page_user.dart';
import 'package:final_project/user/items_details_page.dart';
import 'package:final_project/user/show_items.dart';
import 'package:final_project/user/show_section_page.dart';
import 'package:final_project/user/show_section_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AuthenticationProvider()),
        ChangeNotifierProxyProvider<AuthenticationProvider, ShopProvider>(
            create: (ctx) => ShopProvider(),
            update: (ctx, authProvider, oldShopsProvider) {
              oldShopsProvider.idToken = authProvider.idToken;
              return oldShopsProvider;
            }),
        ChangeNotifierProxyProvider<AuthenticationProvider, SectionProvider>(
            create: (ctx) => SectionProvider(),
            update: (ctx, authProvider, oldSectionsProvider) {
              oldSectionsProvider.idToken = authProvider.idToken;
              return oldSectionsProvider;
            }),
        ChangeNotifierProxyProvider<AuthenticationProvider, ItemsProvider>(
            create: (ctx) => ItemsProvider(),
            update: (ctx, authProvider, oldItemsProvider) {
              oldItemsProvider.idToken = authProvider.idToken;
              return oldItemsProvider;
            }),
      ],
      child: MaterialApp(
        home: ChooseLogin(),
        routes: {
          UserAuthenticationPage.namedRoute: (ctx) => UserAuthenticationPage(),
          AuthenticationPage.namedRoute: (ctx) => AuthenticationPage(),
          LandingPage.namedRoute: (ctx) => LandingPage(),
          ShopsPage.namedRoute: (ctx) => ShopsPage(),
          AddShopPage.namedRoute: (ctx) => AddShopPage(),
          SectionsPage.namedRoute: (ctx) => SectionsPage(),
          ItemPage.namedRoute: (ctx) => ItemPage(),
          AddItemPage.namedRoute: (ctx) => AddItemPage(),
          AddSectionPage.namedRoute: (ctx) => AddSectionPage(),
          ShowItemPage.namedRoute: (ctx) => ShowItemPage(),
          ShowSectionsPage.namedRoute: (ctx) => ShowSectionsPage(),
          ItemDetailsPage.namedRoute: (ctx) => ItemDetailsPage(),
          ChooseLogin.namedRoute: (ctx) => ChooseLogin(),
          ShowItemPageTest.namedRoute: (ctx) => ShowItemPageTest(),
        },
      ),
    );
  }
}

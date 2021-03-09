import 'package:final_project/models/shop.dart';

import 'package:final_project/providers/shops_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddShopPage extends StatefulWidget {
  static const namedRoute = '/add_shop_page';
  @override
  _AddShopPageState createState() => _AddShopPageState();
}

class _AddShopPageState extends State<AddShopPage> {
  var formKey = GlobalKey<FormState>();

  String fName;
  Shop tempShop = Shop();

  String farea;
  String femail;
  String fphoneNumber;
  bool isLoading = false;
  submitForm() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      print('name is : $fName');

      Shop i = Shop(
        id: '-1',
        name: fName,
        email: femail,
        phoneNumber: fphoneNumber,
        area: farea,
        // latitude: 0,
        // longitued: 0,
      );
      setState(() {
        isLoading = true;
      });
      await Provider.of<ShopProvider>(context, listen: false).addShop(i);
      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pop();
    }
  }

  submitEditForm() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      Shop s = Shop(
        id: tempShop.id,
        name: fName,
        area: farea,
        // latitude: tempShop.latitude,
        // longitued: tempShop.longitued,
        phoneNumber: fphoneNumber,
        email: femail,
        logoUrl: tempShop.logoUrl,
      );
      setState(() {
        isLoading = true;
      });
      await Provider.of<ShopProvider>(context, listen: false).editShop(s);
      setState(() {
        isLoading = false;
      });

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var routingData =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    var isEditing = routingData['isEditing'] as bool;

    if (isEditing) {
      tempShop = routingData['shop'] as Shop;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Add shop'), backgroundColor: Colors.red[200]),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(color: Colors.red[200])),
                        initialValue: tempShop.name,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is mandatory to be filled';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          fName = newValue;
                          print(newValue);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Area name',
                            labelStyle: TextStyle(color: Colors.red[200])),
                        initialValue: tempShop.area,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is mandatory to be filled';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          farea = newValue;
                          print(newValue);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Phone number',
                            labelStyle: TextStyle(color: Colors.red[200])),
                        textInputAction: TextInputAction.next,
                        initialValue: tempShop.phoneNumber,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is mandatory to be filled';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          print(newValue);
                          fphoneNumber = newValue;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.red[200])),
                        initialValue: tempShop.email,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'This field is mandatory to be filled';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          print(newValue);
                          femail = newValue;
                        },
                      ),
                      RaisedButton(
                        color: Colors.red[200],
                        onPressed: () {
                          if (isEditing) {
                            submitEditForm();
                          } else {
                            submitForm();
                          }
                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

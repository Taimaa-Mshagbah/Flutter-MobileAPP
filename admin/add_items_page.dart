import 'package:final_project/models/item.dart';
import 'package:final_project/providers/Sections_provider.dart';

import 'package:final_project/providers/items_provider.dart';
import 'package:final_project/providers/shops_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddItemPage extends StatefulWidget {
  static const namedRoute = '/add_Item_page';

  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  File _imageFile;
  final picker = ImagePicker();
  double fPrice;

  double fSpecialPrice;
  String fshopName;
  String fsectionName;
  String fshopId;

  String fName;

  String fDescription;

  bool isLoading = false;
  Item tempItem = Item(
    id: '-1',
    sectionId: '1',
    shopId: '1',
    sectionName: '',
    shopName: '',
    name: '',
    price: 0,
    speacalPrice: 0,
    descrption: '',
    imageUrl: '',
  );

  Future<String> uploadImagetoFirebase() async {
    var imageName = DateTime.now().millisecondsSinceEpoch.toString();
    var firebaseStorageReference =
        FirebaseStorage.instance.ref().child('uploads/$imageName');
    var uploadTask = await firebaseStorageReference.putFile(_imageFile);
    print('finished uploading');
    var downloadURL = uploadTask.ref.getDownloadURL();

    return downloadURL;
  }

  void submitForm(bool isAdding) async {
    if (_imageFile != null) {
      if (formKey.currentState.validate()) {
        formKey.currentState.save();

        try {
          if (isAdding) {
            var imageURL = await uploadImagetoFirebase();
            tempItem.imageUrl = imageURL;
            print(imageURL);
            await Provider.of<ItemsProvider>(context, listen: false)
                .addItem(tempItem);
          } else {
            await Provider.of<ItemsProvider>(context, listen: false)
                .editItem(tempItem);
          }
        } catch (error) {
          print('err in add page');
          await showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Something went wrong'),
                content: Text('an error was thrown while adding an item'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text('Back'),
                  )
                ],
              );
            },
          );
        } finally {
          setState(
            () {
              isLoading = false;
              Navigator.of(context).pop();
            },
          );
        }
      }
    } else {
      if (formKey.currentState.validate()) {
        formKey.currentState.save();

        if (isAdding) {
          var imageURL = await uploadImagetoFirebase();
          tempItem.imageUrl = imageURL;
          print(imageURL);
          await Provider.of<ItemsProvider>(context, listen: false)
              .addItem(tempItem);
        } else {
          await Provider.of<ItemsProvider>(context, listen: false)
              .editItem(tempItem);
        }
      }
      print('you are in the submit else');
    }
  }

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    // var routingData =
    //     ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    // bool isAdding = routingData['isAdding'];
    // if (isAdding == false) {
    //   tempItem = routingData['item'];
    //   print('it is not adding');
    // }
    var routingData =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    var sectionId = routingData['sectionId'];
    var section = Provider.of<SectionProvider>(context, listen: false)
        .getSectionById(sectionId);
    // var shop = Provider.of<ShopProvider>(context, listen: false)
    //     .getShopById(section.shopId);
    bool isAdding = routingData['isAdding'];
    if (!isAdding) {
      tempItem = routingData['item'];
    } else {
      tempItem.sectionId = section.id;
      //tempItem.shopName = shop.name;
      tempItem.sectionName = section.name;
      // tempItem.shopId = shop.id;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        title: Text('Add item'),
      ),
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
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field is mandatory to be filled';
                        }
                        return null;
                      },
                      initialValue: tempItem.name,
                      onSaved: (newValue) {
                        tempItem.name = newValue;
                        print(newValue);
                      },
                    ),
                    TextFormField(
                      initialValue: tempItem.descrption,
                      onSaved: (newValue) {
                        tempItem.descrption = newValue;
                        print(newValue);
                      },
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: Colors.red[200])),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field is mandatory to be filled';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: tempItem.price.toString(),
                      onSaved: (newValue) {
                        print(newValue);
                        tempItem.price = double.parse(newValue);
                      },
                      decoration: InputDecoration(
                          labelText: 'Price',
                          labelStyle: TextStyle(color: Colors.red[200])),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field is mandatory to be filled';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: tempItem.speacalPrice.toString(),
                      onSaved: (newValue) {
                        print(newValue);
                        tempItem.speacalPrice = double.parse(newValue);
                      },
                      decoration: InputDecoration(
                          labelText: 'Special price',
                          labelStyle: TextStyle(color: Colors.red[200])),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'This field is mandatory to be filled';
                        }
                        return null;
                      },
                    ),
                    RaisedButton(
                      onPressed: () {
                        submitForm(isAdding);
                      },
                      child: Text('Submit'),
                    ),
                    SizedBox(
                      child: RaisedButton(
                        onPressed: () {
                          pickImage();
                        },
                        child: Text('Upload image'),
                      ),
                    ),
                    if (_imageFile != null)
                      SizedBox(child: Image.file(_imageFile)),
                  ],
                ),
              )),
            ),
    );
  }
}

import 'dart:io';

import 'package:final_project/models/item.dart';
import 'package:final_project/providers/items_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

//void main() => runApp(MyApp());
class IploadImage extends StatefulWidget {
  @override
  _IploadImageState createState() => _IploadImageState();
}

class _IploadImageState extends State<IploadImage> {
  @override
  final Color yellow = Color(0xfffbc31b);
  final Color orange = Color(0xfffb6900);
  var formKey = GlobalKey<FormState>();

  File _imageFile;
  final picker = ImagePicker();
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

  Future<String> uploadImageToFirebase(BuildContext context) async {
    var imageName = DateTime.now().millisecondsSinceEpoch.toString();
    var firebaseStorageReference =
        FirebaseStorage.instance.ref().child('uploads/$imageName');
    var uploadTask = await firebaseStorageReference.putFile(_imageFile);
    print('finished uploading');
    var downloadURL = uploadTask.ref.getDownloadURL();

    return downloadURL;
  }

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  // void submitForm(bool isAdding) async {
  //   if (_imageFile != null) {
  //     if (formKey.currentState.validate()) {
  //       formKey.currentState.save();

  //       try {
  //         if (isAdding) {
  //           var imageURL = await uploadImageToFirebase(context);
  //           tempItem.imageUrl = imageURL;
  //           print(imageURL);
  //           await Provider.of<ItemsProvider>(context, listen: false)
  //               .addItem(tempItem);
  //         } else {
  //           await Provider.of<ItemsProvider>(context, listen: false)
  //               .editItem(tempItem);
  //         }
  //       } catch (error) {
  //         print('err in add page');
  //         await showDialog(
  //           context: context,
  //           builder: (ctx) {
  //             return AlertDialog(
  //               title: Text('Something went wrong'),
  //               content: Text('an error was thrown while adding an item'),
  //               actions: [
  //                 FlatButton(
  //                   onPressed: () {
  //                     Navigator.of(ctx).pop();
  //                   },
  //                   child: Text('Back'),
  //                 )
  //               ],
  //             );
  //           },
  //         );
  //       } finally {}
  //     }
  //   } else {}
  // }

  // Future uploadImageToFirebase(BuildContext context) async {
  //   String fileName = basename(_imageFile.path);
  //   StorageReference firebaseStorageRef =
  //       FirebaseStorage.instance.ref().child('uploads/$fileName');
  //   StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
  //   StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  //   taskSnapshot.ref.getDownloadURL().then(
  //         (value) => print("Done: $value"),
  //       );
  // }

  @override
  Widget build(BuildContext context) {
    var routingData =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    // bool isAdding = routingData['isAdding'];
    // if (isAdding == false) {
    //   tempItem = routingData['item'];
    // }

    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
        height: 360,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0)),
            gradient: LinearGradient(
                colors: [orange, yellow],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
      ),
      Container(
          margin: const EdgeInsets.only(top: 80),
          child: Column(children: <Widget>[
            Padding(
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
                    // RaisedButton(
                    //   onPressed: () {
                    //     submitForm(isAdding);
                    //                           },
                    //                           child: Text('Submit'),
                    //                         ),
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
          ]))
    ]));
  }
}

//                 padding: const EdgeInsets.all(8.0),
//                 child: Center(
//                   child: Text(
//                     "Uploading Image to Firebase Storage",
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 28,
//                         fontStyle: FontStyle.italic),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20.0),
//               Expanded(
//                 child: Stack(
//                   children: <Widget>[
//                     Container(
//                       height: double.infinity,
//                       margin: const EdgeInsets.only(
//                           left: 30.0, right: 30.0, top: 10.0),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(30.0),
//                         child: _imageFile != null
//                             ? Image.file(_imageFile)
//                             : FlatButton(
//                                 child: Icon(
//                                   Icons.add_a_photo,
//                                   size: 50,
//                                 ),
//                                 onPressed: pickImage,
//                               ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               uploadImageButton(context),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// Widget uploadImageButton(BuildContext context) {
//   return Container(
//     child: Stack(
//       children: <Widget>[
//         Container(
//           padding:
//               const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
//           margin: const EdgeInsets.only(
//               top: 30, left: 20.0, right: 20.0, bottom: 20.0),
//           decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [yellow, orange],
//               ),
//               borderRadius: BorderRadius.circular(30.0)),
//           child: FlatButton(
//             onPressed: () => uploadImageToFirebase(context),
//             child: Text(
//               "Upload Image",
//               style: TextStyle(fontSize: 20),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

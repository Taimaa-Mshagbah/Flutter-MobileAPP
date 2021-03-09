import 'package:final_project/models/Section.dart';
import 'package:final_project/providers/Sections_provider.dart';

//import 'package:final_project/providers/shops_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSectionPage extends StatefulWidget {
  static const namedRoute = '/add_section_page';
  @override
  _AddSectionPageState createState() => _AddSectionPageState();
}

class _AddSectionPageState extends State<AddSectionPage> {
  var formKey = GlobalKey<FormState>();

  String fName;
  Section tempSection = Section();
  bool isLoading = false;
  submitForm(bool isEditing) async {
    var routeData =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    var shopId = routeData['shopId'] as String;
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      Section s = Section(
        id: isEditing ? tempSection.id : '-1',
        name: fName,
        shopId: shopId,
      );
      setState(() {
        isLoading = true;
      });
      if (isEditing) {
        await Provider.of<SectionProvider>(context, listen: false)
            .editSection(s);
        setState(() {
          isLoading = false;
        });

        Navigator.of(context).pop();
      } else {
        await Provider.of<SectionProvider>(context, listen: false)
            .addSection(s);
        setState(() {
          isLoading = false;
        });

        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var routingData =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;

    bool isEditing = routingData['isEditing'] as bool;
    if (isEditing) {
      tempSection = routingData['section'] as Section;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        title: Text('Add Section'),
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
                        initialValue: tempSection.name,
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
                      RaisedButton(
                        onPressed: () {
                          submitForm(isEditing);
                        },
                        child: Text('Save'),
                        color: Colors.red[200],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

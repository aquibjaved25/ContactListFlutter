import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterappcontactassignment/model/contact_model.dart';
import 'package:flutterappcontactassignment/utils/database_helper.dart';
import 'package:image_picker/image_picker.dart';

class ContactDetail extends StatefulWidget {
  final String appBarTitle;
  final ContactModel contactModel;

  ContactDetail(this.contactModel, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return ContactDetailState(this.contactModel, this.appBarTitle);
  }
}

class ContactDetailState extends State<ContactDetail> {
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  ContactModel contactModel;

  File _image;

  String path;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController landlineController = TextEditingController();

  ContactDetailState(this.contactModel, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    if (contactModel.imagePath.length > 3) {
      _image = File(contactModel.imagePath);
    } else {
      _image = null;
    }
    nameController.text = contactModel.name;
    mobileController.text = contactModel.mobile;
    landlineController.text = contactModel.landline;

    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Write some code to control things, when user press back button in AppBar
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                // First element
                Center(
                  child: GestureDetector(
                    child: _image == null
                        ? CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                AssetImage('images/imgplaceholder.png'))
                        : CircleAvatar(
                            radius: 60,
                        backgroundImage: FileImage(_image)),
                    onTap: () {
                      debugPrint('On Image Tap');
                      _openCamera();
                    },
                  ),
                ),
                // Second Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: nameController,
                    style: textStyle,
                    maxLines: 1,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateName();
                    },
                    decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Third Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: mobileController,
                    style: textStyle,
                    maxLength: 10,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateMobile();
                    },
                    decoration: InputDecoration(
                        labelText: 'Mobile',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Fourth Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: landlineController,
                    style: textStyle,
                    maxLength: 10,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updatelandline();
                    },
                    decoration: InputDecoration(
                        labelText: 'Landline',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                ),

                // Fifth Element
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              if(_validation()) {
                                _save();
                              }
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                        child: RaisedButton(
                          color: contactModel.favorite == 1
                              ? Theme.of(context).primaryColorDark
                              : Theme.of(context).primaryColorLight,
                          textColor: contactModel.favorite == 1
                              ? Colors.white
                              : Colors.grey,
                          child: Text(
                            'Favorite',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Favorite button clicked");
                              if (contactModel.favorite == 1) {
                                contactModel.favorite = 2;
                              } else {
                                contactModel.favorite = 1;
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of Note object
  void updateName() {
    contactModel.name = nameController.text;
  }

  bool _validation(){
    if(contactModel.name.isEmpty){
      _showAlertDialog('Name cannot be empty', 'Please enter Name');
      return false;
    }if(contactModel.mobile.isEmpty){
      _showAlertDialog('Mobile number cannot be empty', 'Please enter Mobile number');
      return false;
    }if(contactModel.landline.isEmpty){
      _showAlertDialog('Landline number cannot be empty', 'Please enter Landline number');
      return false;
    }if(contactModel.landline.length != 10){
      _showAlertDialog('Landline number invalid', 'Please enter valid Landline number');
      return false;
    }if(contactModel.mobile.length != 10){
      _showAlertDialog('Mobile number invalid', 'Please enter valid Mobile number');
      return false;
    }if(_image == null){
      _showAlertDialog('Please select Image', 'Please click Image');
      return false;
    }
    return true;
  }

  // Update the description of Note object
  void updateMobile() {
    contactModel.mobile = mobileController.text;
  }

  void updatelandline() {
    contactModel.landline = landlineController.text;
  }

  // Save data to database
  void _save() async {
    moveToLastScreen();

    //contactModel.landline = "landline number";
    //contactModel.imagePath = _image.path;
    int result;
    debugPrint("contact details are $contactModel");
    if (contactModel.id != null) {
      // Case 1: Update operation
      result = await helper.updateContact(contactModel);
      debugPrint("id not null");
    } else {
      // Case 2: Insert Operation
      debugPrint("id null");
      result = await helper.insertContact(contactModel);
    }
    debugPrint("id $result");
    if (result != 0) {
      // Success
      debugPrint("Contact Saved Successfully");
      _showAlertDialog('Status', 'Contact Saved Successfully');
    } else {
      // Failure
      debugPrint("Contact didnot Saved Successfully");
      _showAlertDialog('Status', 'Problem Saving Note');
    }
  }


  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _openCamera() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
      contactModel.imagePath = _image.path;
    });
  }
}

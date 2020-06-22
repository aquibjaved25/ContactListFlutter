import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutterappcontactassignment/model/contact_model.dart';
import 'package:flutterappcontactassignment/utils/database_helper.dart';
import 'package:flutterappcontactassignment/screens/contact_detail.dart';
import 'package:sqflite/sqflite.dart';


class ContactList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {

    return ContactListState();
  }
}

class ContactListState extends State<ContactList> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<ContactModel> contactList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if (contactList == null) {
      contactList = List<ContactModel>();
      updateListView();
    }

    return Scaffold(

      body: getContactListView(),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('FAB clicked');
          navigateToDetail(ContactModel('', '', 2,"",""), 'Add Contact');
        },

        tooltip: 'Add Contact',

        child: Icon(Icons.add),

      ),
    );
  }

  ListView getContactListView() {

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(

            leading: CircleAvatar(
              //backgroundColor: getPriorityColor(this.contactList[position].favorite),
              //child: getPriorityIcon(this.contactList[position].favorite),

              radius: 25.0,
              backgroundImage: FileImage(File(this.contactList[position].imagePath)) ,
            ),

            title: Text(this.contactList[position].name, style: titleStyle,),

            subtitle: Text(this.contactList[position].landline),

            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.grey,),
              onTap: () {
                _delete(context, contactList[position]);
              },
            ),


            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(this.contactList[position],'Edit Contact');
            },

          ),
        );
      },
    );
  }

  // Returns the priority color
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;

      default:
        return Colors.yellow;
    }
  }

  // Returns the priority icon
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void _delete(BuildContext context, ContactModel note) async {

    int result = await databaseHelper.deleteContact(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Contact Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {

    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(ContactModel note, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ContactDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {

    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {

      Future<List<ContactModel>> noteListFuture = databaseHelper.getContactList();
      noteListFuture.then((noteList) {
        setState(() {
          this.contactList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}

import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget{
  final Function onTap;

  MyDrawer({
    this.onTap
  });
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 30)),
          GestureDetector(
            child: Text(
              "Home",
              style: TextStyle(fontSize: 22),
            ),
            onTap: () {
//              Navigator.of(context).pushReplacement(
//                  MaterialPageRoute(builder: (context) => ContactList()));
              onTap(context,0);
            },
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          GestureDetector(
            child: Text(
              "Favorite",
              style: TextStyle(fontSize: 22),
            ),
            onTap: () {
//              Navigator.of(context).pushReplacement(
//                  MaterialPageRoute(builder: (context) => FavoriteList()));
              onTap(context,1);
            },
          ),
        ],
      ),
    );
  }
}
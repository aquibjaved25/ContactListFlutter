import 'package:flutter/material.dart';
import './screens/contact_list.dart';
import './screens/favorite_list.dart';
import './drawer/main_drawer.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int index = 0;
  List<Widget> list = [
    ContactList(),
    FavoriteList(),
  ];

  List<String>screenList=["Contact List", "Favorite List"];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(screenList[index]),
        ),
        body: list[index],
        drawer: MyDrawer(onTap: (ctx,i){
          setState(() {
            index  = i;
            Navigator.pop(ctx);
          });
        },),
      ),
    );
  }

}
import 'dart:math';

import 'package:flutter/material.dart';
import "package:hive/hive.dart";
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:randomyemek/model/food.dart';

import 'new_food.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var applicationDocumentsDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(applicationDocumentsDirectory.path);
  Hive.registerAdapter(FoodAdapter());
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Yemek',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: Hive.openBox("foods"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return Scaffold(
                appBar: AppBar(
                  title: Text("Yemek Bul"),
                ),
                body: Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: RaisedButton(
                      child: Text("Bul"),
                      onPressed: () {
                        var box = Hive.box("foods");
                        if (box.length > 0) {
                          var index = Random().nextInt(box.length);
                          var food = box.getAt(index) as Food;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: new Text("Buldum"),
                                content: new Text(food.name),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Tamam"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add),
                    tooltip: 'New',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewFoodPage()),
                      );
                    }),
              );
            }
          } else {
            return Scaffold();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'model/food.dart';

class NewFoodPage extends StatefulWidget {
  @override
  _NewFoodPageState createState() => _NewFoodPageState();
}

class _NewFoodPageState extends State<NewFoodPage> {
  final textFieldController = TextEditingController();

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Yemek"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Yemek Adı",
              ),
              controller: textFieldController,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: RaisedButton(
                child: Text("Kaydet"),
                onPressed: () {
                  var text = textFieldController.text;
                  if (null != text) {
                    var box = Hive.box("foods");
                      box.add(Food(text.trim()));
                      Navigator.pop(context);

                  } else {
                    _showDialog("Yemek adı giriniz!");
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Uyarı"),
          content: new Text(error),
          actions: <Widget>[
            FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

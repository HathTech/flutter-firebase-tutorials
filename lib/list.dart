import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryAdmin extends StatelessWidget {
  const CategoryAdmin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
        title: Text(
          "Category",
          style: TextStyle(
              color: Colors.white, fontSize: 24.0, letterSpacing: 1.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 54.0),
              child: Material(
                elevation: 8.0,
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(0.0),
                child: InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.add, color: Colors.white),
                        Padding(padding: EdgeInsets.only(right: 16.0)),
                        Text(
                          'ADD ITEM',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

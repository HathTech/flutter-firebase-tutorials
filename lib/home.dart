import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials/app.dart';
import 'package:firebase_tutorials/model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final User user;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  HomePage({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('items');

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _firebaseAuth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => App(),
                  ),
                );
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Center(
                child: Text(user.phoneNumber),
              ),
              Text(
                'Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: itemRef.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return new ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      final ItemModel item = ItemModel.fromFirestore(document);

                      return new ListTile(
                        title: new Text(item.name),
                        subtitle: new Text(item.description),
                      );
                    }).toList(),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

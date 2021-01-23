import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials/app.dart';
import 'package:firebase_tutorials/model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User user;
  HomePage({Key key, @required this.user})
      : assert(user != null),
        super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<ItemModel> items;
  String errorMessage;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    // getItemsStream();
    getItemsByFilter();
  }

  void getItemsStream() {
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('items');

    itemRef.snapshots().listen((event) {
      if (event != null) {
        setState(() {
          items = event.docs.map((e) => ItemModel.fromFirestore(e)).toList();
        });
      }
    }, onError: (e) {
      setState(() {
        errorMessage = e.toString();
      });
    });
  }

  void getItemsFuture() async {
    try {
      CollectionReference itemRef =
          FirebaseFirestore.instance.collection('items');
      final data = await itemRef.get();
      if (data != null) {
        setState(() {
          items = data.docs.map((e) => ItemModel.fromFirestore(e)).toList();
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  void getItemsByFilter() {
    // HERE I am using user id for filter but you can use any variable
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('items');

    itemRef.where('userId', isEqualTo: widget.user.uid).snapshots().listen(
        (event) {
      if (event != null) {
        setState(() {
          items = event.docs.map((e) => ItemModel.fromFirestore(e)).toList();
        });
      }
    }, onError: (e) {
      setState(() {
        errorMessage = e.toString();
      });
    });
  }

  void getItemsInSortedOrder() {
    // You can sort the record by date and time along with filter
    // but filter you might have to create any index
    CollectionReference itemRef =
        FirebaseFirestore.instance.collection('items');

    itemRef
        .where('userId', isEqualTo: widget.user.uid)
        .where('createdAt',
            isGreaterThan: DateTime.now().subtract(Duration(days: 10)))
        .snapshots()
        .listen((event) {
      if (event != null) {
        setState(() {
          items = event.docs.map((e) => ItemModel.fromFirestore(e)).toList();
        });
      }
    }, onError: (e) {
      setState(() {
        errorMessage = e.toString();
      });
    });
  }

  void addItem(ItemModel item) async {
    try {
      final userId = widget.user.uid;
      CollectionReference itemRef =
          FirebaseFirestore.instance.collection('items');

      // I am showing you without form but you got it how you can add the data to firestore
      await itemRef.add({
        'userId': userId,
        'name': item.name,
        'description': item.description,
        'deleted': false,
        'id': itemRef.id,
        'status': true,
        'featured': item.featured,
        'createdAt': DateTime.now()
      });
    } catch (e) {
      // You can use scaffold to show error
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
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
        onPressed: () {
          addItem(
              ItemModel(name: 'Test Item', description: 'Test Description'));
        },
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
                  child: Text(widget.user.phoneNumber),
                ),
                Text(
                  'Items',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (errorMessage != null) ...[
                  SizedBox(
                    height: 8,
                  ),
                  Text(errorMessage ?? 'Something Went Wrong')
                ] else if (items != null) ...[
                  ListView.builder(
                    itemCount: items.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      final ItemModel item = items[index];
                      return ListTile(
                        title: new Text(item.name),
                        subtitle: new Text(item.description),
                      );
                    },
                  ),
                ] else ...[
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ]
              ]),
        ),
      ),
    );
  }
}

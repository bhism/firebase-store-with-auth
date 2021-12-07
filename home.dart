import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  String email;
  HomePage({
    required this.email,
  });
  @override
  _HomePageState createState() => _HomePageState(email: email);
}

class _HomePageState extends State<HomePage> {
  String email;
  _HomePageState({
    required this.email,
  });
  Stream<QuerySnapshot> comparision(BuildContext context) async* {
    try {
      yield* FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: '${email.toString()}')
          .snapshots();
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Homepage",
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              logout(context);
            },
            child: Text(
              "logout",
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: comparision(context),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Center(
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (_, index) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.data!.docChanges[index].doc['name']),
                      Text(snapshot.data!.docChanges[index].doc['mobile']),
                      Text(snapshot.data!.docChanges[index].doc['email']),
                      Text(
                        "Please press the subscribe button for more videos",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      MaterialButton(
                        color: Colors.red,
                        onPressed: () {},
                        child: Text(
                          'Subscribe',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

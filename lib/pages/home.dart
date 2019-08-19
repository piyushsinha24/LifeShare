import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//
import './auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      systemNavigationBarColor: Colors.black, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: Color.fromARGB(1000, 221, 46, 68),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Home",
          style: TextStyle(
            fontSize: 60.0,
            fontFamily: "SouthernAire",
            color: Colors.white,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Home"),
              leading: Icon(
                Icons.home,
                color: Color.fromARGB(1000, 221, 46, 68),
              ),
              onTap: () {
               Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            HomePage()));
              },
            ),
            ListTile(
              title: Text("Profile"),
              leading: Icon(
                Icons.account_circle,
                color: Color.fromARGB(1000, 221, 46, 68),
              ),
              onTap: () {
                //
              },
            ),
            ListTile(
              title: Text("Logout"),
              leading: Icon(
                Icons.error_outline,
                color: Color.fromARGB(1000, 221, 46, 68),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AuthPage(FirebaseAuth.instance)));
              },
            ),
          ],
        ),
      ),
      body: ClipRRect(
        borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(40.0),
            topRight: const Radius.circular(40.0)),
        child: Container(
          height: 800.0,
          width: double.infinity,
          color: Colors.white,
        ),
      ),
    );
  }
}

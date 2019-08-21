import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//
import './auth.dart';
import './mapView.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseUser currentUser;
  String _name, _bloodgrp, _email;
  Widget _child;

  Future<Null> _fetchUserInfo() async {
    Map<String, dynamic> _userInfo;
    FirebaseUser _currentUser = await FirebaseAuth.instance.currentUser();

    DocumentSnapshot _snapshot = await Firestore.instance
        .collection("User Details")
        .document(_currentUser.uid)
        .get();

    _userInfo = _snapshot.data;

    this.setState(() {
      _name = _userInfo['name'];
      _email = _userInfo['email'];
      _bloodgrp = _userInfo['bloodgroup'];
      _child=_myWidget();
    });
  }

  Future<void> _loadCurrentUser() async{
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState'
    _child=_buildLoadingChild();
    _loadCurrentUser();
    _fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      systemNavigationBarColor: Colors.black, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return _child;
  }
   Widget _buildLoadingChild() {
    return Scaffold(
     body: Center(
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(2.0),
                    child: CircularProgressIndicator()),
                SizedBox(width: 10.0),
                Text(
                  "Loading",
                ),
              ],
            )),
      ),
    );
  }
  Widget _myWidget(){
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
          padding: const EdgeInsets.all(0.0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(1000, 221, 46, 68),
              ),
              accountName: Text(currentUser == null ? "" : _name,style: TextStyle(fontSize: 22.0,),),
              accountEmail: Text(currentUser == null ? "" : _email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  currentUser == null ? "" : _bloodgrp,
                  style: TextStyle(
                    fontSize: 45.0,
                    color: Colors.black54,
                    fontFamily: 'SouthernAire',
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text("Home"),
              leading: Icon(
                Icons.home,
                color: Color.fromARGB(1000, 221, 46, 68),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
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
                        builder: (context) => AuthPage(FirebaseAuth.instance)));
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
          child: MapView(),
        ),
      ),
    );
  }

}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:lifeshare/utils/customDialogs.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//
import 'register.dart';
import 'package:lifeshare/utils/customDialogs.dart';
import './home.dart';

class AuthPage extends StatefulWidget {
  final FirebaseAuth appAuth;
  AuthPage(this.appAuth);
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final formkey = new GlobalKey<FormState>();
  String _email;
  String _password;
  bool validate_save() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validate_submit() async {
    if (validate_save()) {
      try {
        CustomDialogs.progressDialog(context: context, message: 'Signing In');
       FirebaseUser user = (await widget.appAuth.
signInWithEmailAndPassword(email: _email, password: _password))
.user;
        Navigator.pop(context);
        print('Signed in: ${user.uid}');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } catch (e) {
        print('Errr : $e');
        showDialog(
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('User Sign-In Failed !'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      formkey.currentState.reset();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
            context: context);
      }
    }
  }

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
          "LifeShare",
          style: TextStyle(
            fontSize: 60.0,
            fontFamily: "SouthernAire",
            color: Colors.white,
          ),
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
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Container(
                      height: 180.0, child: Image.asset("assets/logo.png")),
                ),
                new Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Email ID',
                            icon: Icon(
                              Icons.mail_outline,
                              color: Color.fromARGB(1000, 221, 46, 68),
                            ),
                          ),
                          validator: (value) => value.isEmpty
                              ? "Email ID field can't be empty"
                              : null,
                          onSaved: (value) => _email = value,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Password',
                            icon: Icon(
                              Icons.lock_outline,
                              color: Color.fromARGB(1000, 221, 46, 68),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) => value.isEmpty
                              ? "Password field can't be empty"
                              : null,
                          onSaved: (value) => _password = value,
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      RaisedButton(
                        onPressed: validate_submit,
                        textColor: Colors.white,
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        color: Color.fromARGB(1000, 221, 46, 68),
                        child: Text("LOGIN"),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("New User? "),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterPage(widget.appAuth)));
                                },
                                child: Text(
                                  "Click here",
                                  style: TextStyle(
                                    color: Color.fromARGB(1000, 221, 46, 68),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

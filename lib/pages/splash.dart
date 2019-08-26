import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
//pages import
import './auth.dart';
import './home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation _logoAnimation;
  AnimationController _logoController;
  final FirebaseAuth appAuth = FirebaseAuth.instance;
  @override
  void initState() {
    _logoController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );

    _logoAnimation.addListener(() {
      if (_logoAnimation.status == AnimationStatus.completed) {
        return;
      }
      this.setState(() {});
    });

    _logoController.forward();
    super.initState();
    startTime();
  }

  Widget _buildLogo() {
    return Center(
      child: Container(
        height: _logoAnimation.value*250.0,
        width: _logoAnimation.value*250.0,
        child: Image.asset("assets/logo.png"),
      ),
    );
  }

  Future<void> navigationPage() async {
    FirebaseUser currentUser = await appAuth.currentUser();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                currentUser == null ? AuthPage(appAuth) : HomePage()));
  }

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body:  _buildLogo(),
    );
  }
}

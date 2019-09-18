import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
//pages import

//utils import
import 'package:lifeshare/utils/customDialogs.dart';

class CampaignsPage extends StatefulWidget {
  @override
  _CampaignsPageState createState() => _CampaignsPageState();
}

class _CampaignsPageState extends State<CampaignsPage> {
  FirebaseUser currentUser;
  final formkey = new GlobalKey<FormState>();
  String _text, _name;
  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(_user) async {
    if (isLoggedIn()) {
      Firestore.instance
          .collection('Campaign Details')
          .document()
          .setData(_user)
          .catchError((e) {
        print(e);
      });
    } else {
      print('You need to be logged In');
    }
  }

  Future<void> _loadCurrentUser() async {
    await FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      setState(() {
        // call setState to rebuild the view
        this.currentUser = user;
      });
    });
  }

  Future<bool> dialogTrigger(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Post Submitted'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  formkey.currentState.reset();
                  Navigator.pop(context);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => CampaignsPage()));
                },
                child: Icon(
                  Icons.arrow_forward,
                  color: Color.fromARGB(1000, 221, 46, 68),
                ),
              ),
            ],
          );
        });
  }
 File _image;
  String _path;

  Future getImage(bool isCamera) async {
    File image;
    String path;
    if (isCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
      path = image.path;
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
      path = image.path;
    }
    setState(() {
      _image = image;
      _path = path;
    });
  }

  Future<String> uploadImage() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('campaignposters/${user.uid}/$_name.jpg');
    StorageUploadTask uploadTask = storageReference.putFile(_image);

    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      systemNavigationBarColor: Colors.black, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(1000, 221, 46, 68),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Campaigns",
          style: TextStyle(
            fontSize: 60.0,
            fontFamily: "SouthernAire",
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            FontAwesomeIcons.reply,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
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
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FloatingActionButton(
            backgroundColor: Color.fromARGB(1000, 221, 46, 68),
            child: Icon(
              FontAwesomeIcons.pen,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Make a post about your campaign"),
                  content: Form(
                    key: formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Organisation name',
                                icon: Icon(
                                  FontAwesomeIcons.user,
                                  color: Color.fromARGB(1000, 221, 46, 68),
                                ),
                              ),
                              validator: (value) => value.isEmpty
                                  ? "This field can't be empty"
                                  : null,
                              onSaved: (value) => _name = value,
                              keyboardType: TextInputType.multiline,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Wite something here',
                                icon: Icon(
                                  FontAwesomeIcons.pen,
                                  color: Color.fromARGB(1000, 221, 46, 68),
                                ),
                              ),
                              validator: (value) => value.isEmpty
                                  ? "This field can't be empty"
                                  : null,
                              onSaved: (value) => _text = value,
                              keyboardType: TextInputType.multiline,
                              maxLength: 120,
                            ),
                          ),
                         Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () {
                              getImage(true);
                            }),
                        IconButton(
                            icon: Icon(Icons.filter),
                            onPressed: () {
                              getImage(false);
                            }),
                      ],
                    ),
                    _image == null
                        ? Container()
                        : Image.file(
                            _image,
                            height: 150.0,
                            width: 150.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: <Widget>[
                    RaisedButton(
                      color: Color.fromARGB(1000, 221, 46, 68),
                      onPressed: ()async {
                        if (!formkey.currentState.validate()) return;
                        formkey.currentState.save();
                         CustomDialogs.progressDialog(
                            context: context, message: 'Uploading');
                        var url = await uploadImage();
                        Navigator.of(context).pop();
                        final Map<String, dynamic> campaignDetails = {
                          'uid': currentUser.uid,
                          'content': _text,
                          'image': url,
                          'name': _name,
                        };
                        addData(campaignDetails).then((result) {
                          dialogTrigger(context);
                        }).catchError((e) {
                          print(e);
                        });
                      },
                      child: Text(
                        'POST',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

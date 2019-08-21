import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RequestBlood extends StatefulWidget {
  @override
  _RequestBloodState createState() => _RequestBloodState();
}

class _RequestBloodState extends State<RequestBlood> {
  final formkey = new GlobalKey<FormState>();
  List<String> _bloodGroup = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  String _selected = '';
  String _qty;
  bool _categorySelected = false;
  DateTime selectedDate = DateTime.now();
  int flag=0;
  Future<Null> _selectDate(BuildContext context) async {
    flag=1;
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: selectedDate,
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(1000, 221, 46, 68),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(
          "Request Blood",
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
                new Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 20.0),
                              child: DropdownButton(
                                hint: Text(
                                  'Please choose a Blood Group',
                                  style: TextStyle(
                                    color: Color.fromARGB(1000, 221, 46, 68),
                                  ),
                                ),
                                iconSize: 40.0,
                                items: _bloodGroup.map((val) {
                                  return new DropdownMenuItem<String>(
                                    value: val,
                                    child: new Text(val),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selected = newValue;
                                    this._categorySelected = true;
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              _selected,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Color.fromARGB(1000, 221, 46, 68),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Quantity(L)',
                            icon: Icon(
                              FontAwesomeIcons.prescriptionBottle,
                              color: Color.fromARGB(1000, 221, 46, 68),
                            ),
                          ),
                          validator: (value) => value.isEmpty
                              ? "Name field can't be empty"
                              : null,
                          onSaved: (value) => _qty = value,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () => _selectDate(context),
                              icon: Icon(FontAwesomeIcons.calendar),
                              color: Color.fromARGB(1000, 221, 46, 68),
                            ),
                             flag==0?Text("Due Date",style: TextStyle(color: Colors.black54,fontSize: 15.0),):Text("${selectedDate.toLocal()}"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      RaisedButton(
                        onPressed: () {},
                        textColor: Colors.white,
                        padding: EdgeInsets.only(left: 5.0, right: 5.0),
                        color: Color.fromARGB(1000, 221, 46, 68),
                        child: Text("SUBMIT"),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
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

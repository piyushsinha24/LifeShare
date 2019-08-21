import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
//
import './requestBlood.dart';
class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController _controller;
  bool isMapCreated = false;
  Position position;
  Widget _child;
  BitmapDescriptor bitmapImage;
  Marker marker;
  Uint8List markerIcon;

  @override
  void initState() {
    _child = _buildLoadingChild();
    getIcon();
    getCurrentLocation();
    super.initState();
  }

  void getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    setState(() {
      position = res;
      _child = mapWidget();
    });

    print(position.latitude);
    print(position.longitude);
  }

  void getIcon() async {
    markerIcon = await getBytesFromAsset('assets/marker2.png', 120);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("marker_1"),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.fromBytes(markerIcon),
      ),
    ].toSet();
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setmapstyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }
  @override
  Widget build(BuildContext context) {
    if (isMapCreated) {
      getJsonFile('assets/customStyle.json').then(setmapstyle);
    }
    return _child;
  }

  Widget mapWidget() {
    return Stack(
          children:<Widget>[ GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 16.0,
        ),
        markers: _createMarker(),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          isMapCreated = true;
          getJsonFile('assets/customStyle.json').then(setmapstyle);
        },
      ),
      Align(
        alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton.extended(
          backgroundColor:Color.fromARGB(1000, 221, 46, 68), 
          onPressed: (){
             Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RequestBlood(position.latitude,position.longitude)));
          },
         icon: Icon(FontAwesomeIcons.burn),
         label: Text("Request Blood"),
        ),
              ),
      )
      ],
    );
  }

  Widget _buildLoadingChild() {
    return Center(
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
                "Getting Location",
              ),
            ],
          )),
    );
  }
}

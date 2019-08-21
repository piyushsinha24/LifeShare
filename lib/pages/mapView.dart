import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  GoogleMapController _controller;
  bool isMapCreated = false;
  Position position;
  Widget _child;

  @override
  void initState() {
    _child=_buildLoadingChild();
    getCurrentLocation();
    super.initState();
  }

  void getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    setState((){
      position = res; 
      _child=mapWidget();
    });

    print(position.latitude);
    print(position.longitude);
  }

  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId("marker_1"),
        position: LatLng(position.latitude, position.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
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
  Widget mapWidget(){
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 18.0,
      ),
      markers: _createMarker(),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
        isMapCreated = true;
        getJsonFile('assets/customStyle.json').then(setmapstyle);
      },
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

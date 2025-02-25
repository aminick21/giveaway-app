import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:give_away/utils/colors.dart';
import 'package:latlong2/latlong.dart';

class FullScreenMap extends StatefulWidget {
  double lat;
  double long;
  FullScreenMap({super.key,required this.lat,required this.long});

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FlutterMap(
        mapController: MapController(),
        options: MapOptions(
          initialCenter: LatLng(widget.lat,widget.long),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: LatLng(widget.lat, widget.long),
                child: Icon(Icons.location_on, color:secondaryColor, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

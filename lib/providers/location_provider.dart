import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationProvider extends ChangeNotifier {
  Location location = Location();
  LocationData? _currentLocation;
  bool _permission = false;

  get hasPermission=>_permission;
  LocationData? get currentLocation => _currentLocation;


  Future<void> updateLocation() async {


    // Check if location services are enabled
    bool _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // Handle the case when the user doesn't enable location services
        _permission=false;
        notifyListeners();
        return;
      }
    }

    // Check if location permission is granted
    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        // Handle the case when the user denies location permission
        _permission=false;
        notifyListeners();
        return;
      }
    }


    // Get the current location
    try {
      _currentLocation = await location.getLocation();
      _permission = true;
      notifyListeners();
    } catch (e) {
      print('Error updating location: $e');
    }

  }

  requestPermission() async {

    // Check if location services are enabled
    bool _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        // Handle the case when the user doesn't enable location services
        _permission=false;
        notifyListeners();
        return;
      }
    }
    // Check if location permission is granted
    PermissionStatus _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        // Handle the case when the user denies location permission
        _permission=false;
        notifyListeners();
        return;
      }
    }
    else{
      _permission = true;
      notifyListeners();
    }
  }



}

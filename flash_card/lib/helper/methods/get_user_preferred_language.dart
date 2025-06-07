// TO get the device locale with Dart UI.  Goal is to get the language code and country code of the device

import 'package:flutter/material.dart'; // To get the app locale with Flutter Material. Goal is to get the language code and country code of the device
import 'dart:ui' as ui;

import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

//late SharedPreferences? prefs;

//With Dart UI
Future<void> getUserPreferredLanguage() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  //Get the device locale
  final deviceLocale = ui.PlatformDispatcher.instance.locale;
  debugPrint("ui.PlatformDispatcher.instance.locale: $deviceLocale");

  final countryCode = deviceLocale.countryCode;
  debugPrint("Country Code: $countryCode");

  final languageCode = deviceLocale.languageCode;
  debugPrint("Language Code: $languageCode");

  //Save the language code to the shared preferences
  if (prefs.getString("preferredUserLanguage") != languageCode) {
    await prefs.setString("preferredUserLanguage", languageCode);
    debugPrint("Preferred User Language saved");
  } else {
    debugPrint("Preferred User Language already saved");
  }
}

//Geolocator (unused for now)
Future<Position> getLocationUserData() async {
  debugPrint("getUserLocations - Getting user location ...");
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  /* debugPrint(
    "getUserLocations - Location services are enabled: $serviceEnabled",
  ); */

  if (!serviceEnabled) {
    debugPrint("getUserLocations - Location services are disabled");
    return Future.error('Location services are disabled.');
  }

  //Check permission
  //debugPrint("getUserLocations - About to check permission...");
  try {
    permission = await Geolocator.checkPermission().timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        // debugPrint("getUserLocations - Permission check timed out");
        return LocationPermission.denied;
      },
    );
    // debugPrint("getUserLocations - Location permission: $permission");
  } catch (e) {
    //debugPrint("getUserLocations - Error checking permission: $e");
    return Future.error('Error checking location permission: $e');
  }

  //Request permission
  if (permission == LocationPermission.denied) {
    //debugPrint("Location permissions are denied");
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      //debugPrint("getUserLocations - Location permissions are denied again");
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    //debugPrint("getUserLocations - Location permissions are denied forever");
    return Future.error('Location permissions are denied forever');
  }

  //--
  final lastKnownPosition = await Geolocator.getLastKnownPosition();
  //  debugPrint("getUserLocations - Last known position: $lastKnownPosition");
  if (lastKnownPosition == null) {
    //debugPrint("getUserLocations - No last known position found");
    //return await Geolocator.getCurrentPosition();
  }

  //--

  //Get the current position
  return await Geolocator.getCurrentPosition();
}

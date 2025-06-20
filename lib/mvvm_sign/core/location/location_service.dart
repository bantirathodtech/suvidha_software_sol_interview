import 'package:geolocator/geolocator.dart';

import 'constants/utils.dart';

class LocationService {
  static String currentLatitude = "0.0";
  static String currentLongitude = "0.0";

  // Check location permissions and get the current location
  static Future<bool> checkLocationPermission() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        printMessage("Location services are disabled.");
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          printMessage("Location permissions are denied.");
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        printMessage("Location permissions are permanently denied.");
        return false;
      }

      printMessage("Permission Granted");
      await getCurrentLocation();
      return true;
    } catch (e) {
      printMessage("Error checking location permission: $e");
      return false;
    }
  }

  // Fetch the current location and update latitude/longitude
  static Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (checkStatus(position.latitude.toString())) {
        currentLatitude = checkString(position.latitude.toString());
        currentLongitude = checkString(position.longitude.toString());
      }
      printMessage("currentLatitude: $currentLatitude");
      printMessage("currentLongitude: $currentLongitude");
    } catch (e) {
      printMessage("Error getting location: $e");
    }
  }

  // Get the current position, if available
  static Future<Position?> getPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      printMessage("Error getting position: $e");
      return null;
    }
  }
}

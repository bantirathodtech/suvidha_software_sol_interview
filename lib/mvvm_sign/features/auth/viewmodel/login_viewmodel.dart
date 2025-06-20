import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../../core/location/data/location_storage.dart';
import '../../../core/location/location_service.dart';
import '../../../core/location/model/location_data_model.dart';
import '../repository/login_repository.dart';

class SignInViewModel extends ChangeNotifier {
  final LoginRepository repository = LoginRepository();

  String _email = '';
  String _password = '';
  bool isLoading = false;
  String? errorMessage;

  String get email => _email;
  String get password => _password;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  Future<bool> signIn() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    if (_email.isEmpty || _password.isEmpty) {
      errorMessage = 'Please enter email and password';
      isLoading = false;
      notifyListeners();
      return false;
    }

    final result = await repository.loginRepository(_email, _password);
    if (result != null && result.status) {
      // Check and request location permission
      bool hasPermission = await LocationService.checkLocationPermission();
      if (!hasPermission) {
        errorMessage = 'Location permission denied';
        isLoading = false;
        notifyListeners();
        return false;
      }

      // Get current position
      Position? position = await LocationService.getPosition();
      if (position == null) {
        errorMessage = 'Failed to get current location';
        isLoading = false;
        notifyListeners();
        return false;
      }

      // Reverse Geocoding
      String fullAddress = "Unknown";
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          fullAddress =
              "${place.name ?? ''}, ${place.street ?? ''}, ${place.subLocality ?? ''}, "
              "${place.locality ?? ''} ${place.postalCode ?? ''}, ${place.administrativeArea ?? ''}";
        }
      } catch (e) {
        print("Reverse geocoding failed: $e");
      }

      final now = DateTime.now();
      final locationModel = LocationDataModel(
        checkInDate: DateFormat('yyyy-MM-dd').format(now),
        checkInTime: DateFormat('HH:mm:ss').format(now),
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
        checkInType: "Login",
        imageUrl: "",
        address: fullAddress.trim(),
      );
      await LocationStorage.saveCheckInData(locationModel);

      isLoading = false;
      notifyListeners();
      return true;
    } else {
      errorMessage = 'Invalid credentials';
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

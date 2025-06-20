import 'package:flutter/material.dart';

import '../../../core/location/data/location_storage.dart';
import '../../../core/location/model/location_data_model.dart';
import '../model/signin_model.dart';

class ProfileViewModel extends ChangeNotifier {
  Datum? _user;
  LocationDataModel? _location;

  Datum? get user => _user;
  LocationDataModel? get location => _location;

  Future<void> setUser(Datum user) async {
    _user = user;
    _location = await LocationStorage.getCheckInData();
    notifyListeners();
  }

  Future<void> refreshLocation() async {
    _location = await LocationStorage.getCheckInData();
    notifyListeners();
  }
}

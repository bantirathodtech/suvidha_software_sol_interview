// location/location_storage.dart
import 'package:shared_preferences/shared_preferences.dart';

import '../model/location_data_model.dart';

class LocationStorage {
  static const String _checkInKey = 'checkInData';

  static Future<void> saveCheckInData(LocationDataModel model) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = convertCheckInDataToJsonString(model);
    await prefs.setString(_checkInKey, jsonString);
  }

  static Future<LocationDataModel?> getCheckInData() async {
    final prefs = await SharedPreferences.getInstance();
    final checkInDataValue = prefs.getString(_checkInKey);

    if (checkInDataValue != null && checkInDataValue.trim().isNotEmpty) {
      return parseJsonToCheckInData(checkInDataValue);
    }
    return null;
  }

  static Future<void> clearCheckInData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_checkInKey);
  }
}

import 'package:flutter/foundation.dart';

void printMessage(String message) {
  if (kDebugMode) {
    print("MyCW.........$message");
  }
}

bool checkStatus(String id) {
  if (id.trim().isEmpty || id == "null") {
    return false;
  }
  return true;
}

String checkString(String value) {
  if (!checkStatus(value)) {
    value = "";
  }
  return value.trim();
}

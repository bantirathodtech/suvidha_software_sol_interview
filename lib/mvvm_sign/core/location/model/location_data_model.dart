import 'dart:convert';

// Function to convert JSON string to model
LocationDataModel parseJsonToCheckInData(String jsonString) =>
    LocationDataModel.fromJson(json.decode(jsonString));
// Function to convert model to JSON string
String convertCheckInDataToJsonString(LocationDataModel model) =>
    json.encode(model.toJson());

class LocationDataModel {
  String? checkInDate;
  String? checkInTime;
  String? latitude;
  String? longitude;
  String? checkInType;
  String? imageUrl;
  String? address;

  LocationDataModel({
    this.checkInDate,
    this.checkInTime,
    this.latitude,
    this.longitude,
    this.checkInType,
    this.imageUrl,
    this.address,
  });

  factory LocationDataModel.fromJson(Map<String, dynamic> json) =>
      LocationDataModel(
        checkInDate: json["checkInDate"].toString(),
        checkInTime: json["checkInTime"].toString(),
        latitude: json["latitude"].toString(),
        longitude: json["longitude"].toString(),
        checkInType: json["checkInType"].toString(),
        imageUrl: json["imageUrl"].toString(),
        address: json["address"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
    "checkInDate": checkInDate,
    "checkInTime": checkInTime,
    "latitude": latitude,
    "longitude": longitude,
    "checkInType": checkInType,
    "imageUrl": imageUrl,
    "address": address,
  };
}

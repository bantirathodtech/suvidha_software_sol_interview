import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapMarkerData {
  final String id;
  final String title;
  final LatLng position;
  final BitmapDescriptor icon;
  final double? rotation;

  MapMarkerData({
    required this.id,
    required this.title,
    required this.position,
    required this.icon,
    this.rotation,
  });
}

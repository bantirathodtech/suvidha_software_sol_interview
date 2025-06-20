// // location/map_display_widget.dart
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// import '../../service/location_service.dart';
//
// class MapDisplayWidget extends StatefulWidget {
//   final double? initialLatitude;
//   final double? initialLongitude;
//
//   const MapDisplayWidget({
//     super.key,
//     this.initialLatitude,
//     this.initialLongitude,
//   });
//
//   @override
//   State<MapDisplayWidget> createState() => _MapDisplayWidgetState();
// }
//
// class _MapDisplayWidgetState extends State<MapDisplayWidget> {
//   late GoogleMapController mapController;
//   late LatLng location;
//
//   @override
//   void initState() {
//     super.initState();
//     location = LatLng(
//         widget.initialLatitude ?? double.parse(LocationService.currentLatitude),
//         widget.initialLongitude ??
//             double.parse(LocationService.currentLongitude));
//   }
//
//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//     mapController.animateCamera(
//       CameraUpdate.newLatLng(location),
//     );
//   }
//
//   Set<Marker> _createMarker() {
//     return {
//       Marker(
//         markerId: const MarkerId('customer_location'),
//         position: location,
//       ),
//     };
//   }
//
//   @override
//   void dispose() {
//     mapController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 250,
//       width: double.maxFinite,
//       child: GoogleMap(
//         mapType: MapType.normal,
//         markers: _createMarker(),
//         onMapCreated: _onMapCreated,
//         initialCameraPosition: CameraPosition(
//           target: location,
//           zoom: 15.0,
//         ),
//       ),
//     );
//   }
// }

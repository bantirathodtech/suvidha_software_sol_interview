import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../model/map_marker_data.dart';

class MapDisplayWidget extends StatefulWidget {
  final LatLng storeLocation;
  final LatLng deliveryLocation;
  final LatLng? currentDeliveryLocation;

  const MapDisplayWidget({
    super.key,
    required this.storeLocation,
    required this.deliveryLocation,
    this.currentDeliveryLocation,
  });

  @override
  State<MapDisplayWidget> createState() => _MapDisplayWidgetState();
}

class _MapDisplayWidgetState extends State<MapDisplayWidget>
    with WidgetsBindingObserver {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Timer? _timer;
  BitmapDescriptor? storeIcon;
  BitmapDescriptor? deliveryIcon;
  BitmapDescriptor? deliveryPersonIcon;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadCustomMarkers();
    _getPolylinePoints();
    _startMarkerAnimation();
  }

  Future<void> _loadCustomMarkers() async {
    // Load custom marker icons
    // final storeMarker =
    //     await _getBytesFromAsset('assets/icons/store_marker.png', 100);
    // final deliveryMarker =
    //     await _getBytesFromAsset('assets/icons/delivery_marker.png', 100);
    // final deliveryPersonMarker =
    //     await _getBytesFromAsset('assets/icons/delivery_person_marker.png', 80);
    // Load custom marker icons
    final storeMarker =
        await getSvgMarker('assets/icons/store_marker.svg', 100);
    final deliveryMarker =
        await getSvgMarker('assets/icons/delivery_marker.svg', 100);
    final deliveryPersonMarker =
        await getSvgMarker('assets/icons/delivery_person_marker.svg', 80);

    setState(() {
      storeIcon = BitmapDescriptor.fromBytes(storeMarker);
      deliveryIcon = BitmapDescriptor.fromBytes(deliveryMarker);
      deliveryPersonIcon = BitmapDescriptor.fromBytes(deliveryPersonMarker);
      _initializeMarkers();
    });
  }

  // Future<Uint8List> _getBytesFromAsset(String path, int width) async {
  //   ByteData data = await rootBundle.load(path);
  //   ui.Codec codec = await ui.instantiateImageCodec(
  //     data.buffer.asUint8List(),
  //     targetWidth: width,
  //   );
  //   ui.FrameInfo fi = await codec.getNextFrame();
  //   return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
  //       .buffer
  //       .asUint8List();
  // }

  static Future<Uint8List> getSvgMarker(String assetName, int width) async {
    try {
      // Load the SVG content
      final String svgContent = await rootBundle.loadString(assetName);

      // Create SVG picture
      final PictureInfo pictureInfo =
          await vg.loadPicture(SvgStringLoader(svgContent), null);

      // Calculate height maintaining aspect ratio
      final double aspectRatio =
          pictureInfo.size.width / pictureInfo.size.height;
      final int height = (width / aspectRatio).round();

      // Create a picture recorder
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);

      // Scale the picture
      canvas.scale(
          width / pictureInfo.size.width, height / pictureInfo.size.height);

      // Draw the picture
      canvas.drawPicture(pictureInfo.picture);

      // Convert to image
      final ui.Image image =
          await recorder.endRecording().toImage(width, height);

      // Get byte data
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) throw Exception('Failed to get byte data');

      // Don't forget to dispose the image
      image.dispose();

      return byteData.buffer.asUint8List();
    } catch (e) {
      print('Error converting SVG to marker: $e');
      throw e;
    }
  }

  void _initializeMarkers() {
    final markers = [
      MapMarkerData(
        id: 'store',
        title: 'Store Location',
        position: widget.storeLocation,
        icon: storeIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
      MapMarkerData(
        id: 'delivery',
        title: 'Delivery Location',
        position: widget.deliveryLocation,
        icon: deliveryIcon ??
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    ];

    if (widget.currentDeliveryLocation != null) {
      markers.add(
        MapMarkerData(
          id: 'delivery_person',
          title: 'Delivery Person',
          position: widget.currentDeliveryLocation!,
          icon: deliveryPersonIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          rotation:
              _calculateBearing(widget.storeLocation, widget.deliveryLocation),
        ),
      );
    }

    setState(() {
      _markers.clear();
      for (var marker in markers) {
        _markers.add(
          Marker(
            markerId: MarkerId(marker.id),
            position: marker.position,
            icon: marker.icon,
            infoWindow: InfoWindow(title: marker.title),
            rotation: marker.rotation ?? 0.0,
            flat: marker.rotation != null,
            anchor: const Offset(0.5, 0.5),
          ),
        );
      }
    });
  }

  // Future<void> _getPolylinePoints() async {
  //   PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
  //     'YOUR_GOOGLE_MAPS_API_KEY', // Replace with your API key
  //     PointLatLng(
  //         widget.storeLocation.latitude, widget.storeLocation.longitude),
  //     PointLatLng(
  //         widget.deliveryLocation.latitude, widget.deliveryLocation.longitude),
  //     travelMode: TravelMode.driving,
  //   );
  //
  //   if (result.points.isNotEmpty) {
  //     polylineCoordinates = result.points
  //         .map((point) => LatLng(point.latitude, point.longitude))
  //         .toList();
  //     _addPolyline();
  //   }
  // }
  Future<void> _getPolylinePoints() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: PolylineRequest(
        origin: PointLatLng(
          widget.storeLocation.latitude,
          widget.storeLocation.longitude,
        ),
        destination: PointLatLng(
          widget.deliveryLocation.latitude,
          widget.deliveryLocation.longitude,
        ),
        mode: TravelMode.driving,
        proxy: null, // Optional proxy
      ),
      googleApiKey: 'AIzaSyBZyXpY8sGWozNNYzM4Kt8WClimmczDlH0',
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
      _addPolyline();
    }
  }

  void _addPolyline() {
    setState(() {
      _polyLines.add(
        Polyline(
          polylineId: const PolylineId('delivery_route'),
          color: Colors.blue.withOpacity(0.8),
          points: polylineCoordinates,
          width: 5,
          patterns: [
            PatternItem.dash(20),
            PatternItem.gap(10),
          ],
          endCap: Cap.roundCap,
          startCap: Cap.roundCap,
        ),
      );
    });
  }

  void _startMarkerAnimation() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted && widget.currentDeliveryLocation != null) {
        _updateDeliveryPersonMarker();
      }
    });
  }

  void _updateDeliveryPersonMarker() {
    if (widget.currentDeliveryLocation == null) return;

    final rotation = _calculateBearing(
      polylineCoordinates[
          _findNearestPointIndex(widget.currentDeliveryLocation!)],
      widget.currentDeliveryLocation!,
    );

    setState(() {
      _markers
          .removeWhere((marker) => marker.markerId.value == 'delivery_person');
      _markers.add(
        Marker(
          markerId: const MarkerId('delivery_person'),
          position: widget.currentDeliveryLocation!,
          icon: deliveryPersonIcon ??
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          rotation: rotation,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          zIndex: 2,
        ),
      );
    });
  }

  int _findNearestPointIndex(LatLng point) {
    int nearestIndex = 0;
    double minDistance = double.infinity;

    for (int i = 0; i < polylineCoordinates.length; i++) {
      final distance = _calculateDistance(point, polylineCoordinates[i]);
      if (distance < minDistance) {
        minDistance = distance;
        nearestIndex = i;
      }
    }

    return nearestIndex;
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    return math.sqrt(
      math.pow(point1.latitude - point2.latitude, 2) +
          math.pow(point1.longitude - point2.longitude, 2),
    );
  }

  double _calculateBearing(LatLng start, LatLng end) {
    final double lat1 = start.latitude * math.pi / 180;
    final double lon1 = start.longitude * math.pi / 180;
    final double lat2 = end.latitude * math.pi / 180;
    final double lon2 = end.longitude * math.pi / 180;

    final double dLon = lon2 - lon1;
    final double y = math.sin(dLon) * math.cos(lat2);
    final double x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    return math.atan2(y, x) * 180 / math.pi;
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _fitBounds();
  }

  void _fitBounds() {
    final bounds = LatLngBounds(
      southwest: LatLng(
        math.min(
            widget.storeLocation.latitude, widget.deliveryLocation.latitude),
        math.min(
            widget.storeLocation.longitude, widget.deliveryLocation.longitude),
      ),
      northeast: LatLng(
        math.max(
            widget.storeLocation.latitude, widget.deliveryLocation.latitude),
        math.max(
            widget.storeLocation.longitude, widget.deliveryLocation.longitude),
      ),
    );

    mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  @override
  void dispose() {
    _timer?.cancel();
    mapController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      markers: _markers,
      polylines: _polyLines,
      initialCameraPosition: CameraPosition(
        target: widget.storeLocation,
        zoom: 15,
      ),
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      buildingsEnabled: true,
      trafficEnabled: false,
    );
  }
}

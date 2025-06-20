import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/location/data/location_storage.dart';
import '../../../core/location/location_service.dart';
import '../../../core/location/model/location_data_model.dart';
import '../viewmodel/profile_viewmodel.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<ProfileViewModel>().user;
    final location = context.watch<ProfileViewModel>().location;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Profile', style: TextStyle(color: Colors.yellow)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.yellow),
      ),
      body: user == null
          ? const Center(
              child: Text(
                "No user data available",
                style: TextStyle(color: Colors.black),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location UI similar to HomeScreen
                  _buildLocationTitle(context, location),
                  const SizedBox(height: 20),
                  // User profile details
                  _profileItem("Full Name", user.personName),
                  _profileItem("Email", user.email),
                  _profileItem("Phone", user.mobileNumber),
                  _profileItem("Role", user.role),
                  _profileItem("Branch ID", user.branchId),
                  _profileItem("Location ID", user.locationId),
                  _profileItem("Financial Year ID", user.financialYearId),
                  _profileItem("Check-in Time", location?.checkInTime ?? "N/A"),
                ],
              ),
            ),
    );
  }

  Widget _buildLocationTitle(
    BuildContext context,
    LocationDataModel? location,
  ) {
    return GestureDetector(
      onTap: () async {
        await LocationService.checkLocationPermission();
        Position? position = await LocationService.getPosition();
        if (position != null) {
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
          final updatedLocation = LocationDataModel(
            checkInDate: DateFormat('yyyy-MM-dd').format(now),
            checkInTime: DateFormat('HH:mm:ss').format(now),
            latitude: position.latitude.toString(),
            longitude: position.longitude.toString(),
            checkInType: "Login",
            imageUrl: "",
            address: fullAddress.trim(),
          );
          await LocationStorage.saveCheckInData(updatedLocation);
          context.read<ProfileViewModel>().setUser(
            context.read<ProfileViewModel>().user!,
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: Colors.green,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                location?.address != null && location!.address!.isNotEmpty
                    ? 'Current Location'
                    : 'Select Address',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              location?.address ?? 'Tap to update location',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}

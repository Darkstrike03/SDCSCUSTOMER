import 'package:geolocator/geolocator.dart';

/// Wraps platform location access so screens can request the user's current
/// position without coupling directly to the geolocator plugin.
class LocationResult {
  final double? latitude;
  final double? longitude;
  final String? error;

  const LocationResult({this.latitude, this.longitude, this.error});

  bool get isSuccess => latitude != null && longitude != null && error == null;
}

class LocationService {
  Future<bool> _ensurePermission() async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false; // caller decides what to show
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  Future<LocationResult> getCurrentPosition() async {
    try {
      final hasPermission = await _ensurePermission();
      if (!hasPermission) {
        return const LocationResult(
          error: 'Location permission denied or disabled.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      return LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (e) {
      return LocationResult(error: 'Could not fetch location: $e');
    }
  }
}

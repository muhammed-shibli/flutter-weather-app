import 'package:geocode/geocode.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitide;
  int? status;
  String apiKey = '4a6b9877b03bb8e33aa7ab12839c2bc8';

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      latitude = position.latitude;
      longitide = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getLocationDetails(String city) async {
    GeoCode geoCode = GeoCode();

    Coordinates coordinates = await geoCode.forwardGeocoding(address: city);
    latitude = coordinates.latitude;
    longitide = coordinates.longitude;
  }
}

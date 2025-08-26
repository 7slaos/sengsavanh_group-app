import 'package:geolocator/geolocator.dart';
class DeterminePosition {

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. ກວດວ່າ GPS ເປີດບໍ
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // 2. ກວດ permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // 3. ດຶງ lat/lng ປະຈຸບັນ
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

}
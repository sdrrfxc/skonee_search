import 'dart:convert';
import 'dart:core';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:skonee_search/models/resultModel.dart';
import 'package:skonee_search/auth/secrets.dart';

class SearchService {
  final httpClient = http.Client();

  Future<List<Result>> getResults(String searchTerm) async {
    final apiKey = secretKey;


    if (searchTerm.toLowerCase().contains("near me")) {
      final indx = searchTerm.toLowerCase().indexOf("near me");
      searchTerm = searchTerm.substring(0, indx);

      searchTerm += await getLocationName(await getUserLoc());
      print(searchTerm);
    }
    final requestUrl =
        'https://api.search.brave.com/res/v1/web/search?q=$searchTerm';
    final response = await httpClient
        .get(Uri.parse(requestUrl), headers: {"X-Subscription-Token": apiKey});

    List<Result> returnResultList = [];
    final json = jsonDecode(response.body);
    final web = json['web'];
    final results = web['results'];
    results
        .toList()
        .forEach((result) => {returnResultList.add(Result.parse(result))});
    return returnResultList;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      LocationPermission permission = await Geolocator.requestPermission();
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<String> getUserLoc() {
    var pos = _determinePosition().then((Position pos) {
      print(pos);
      return '${pos.latitude},${pos.longitude}';
    }).catchError((error, stackTrace) {
      return error.toString();
    });
    return pos;
  }

  Future<String> getLocationName(String cords) async {
    final apiKey = googleSecretKey;
    print(cords);
    final requestUrl =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$cords&key=$apiKey';
    final response = await httpClient
        .get(Uri.parse(requestUrl));
    final resultJson = jsonDecode(response.body);
    final formattedAddress = resultJson['results'].first['formatted_address'];
    print(formattedAddress);
    return formattedAddress;
    }
}

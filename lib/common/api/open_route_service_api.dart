import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:neptune_app/common/util/latlng.dart';

class OpenRouteServiceApi {
  static const String _openRouteServiceBase = 'https://api.openrouteservice.org/v2';
  final String _apiKey;

  OpenRouteServiceApi(String apiKey) : _apiKey = apiKey;

  Future<http.Response> sendOpenStreetRouteRequest({
    required String endpoint,
    required Map<String, Object> body
  }) async {
    Uri uri = Uri.parse('$_openRouteServiceBase/$endpoint');
    String requestJson = jsonEncode(body);

    return await http.post(
      uri,
      headers: {
        'Authorization': _apiKey,
        'Content-type': 'application/json',
      },
      body: requestJson,
    );
  }

  Future<List<LatLng>?> getRoute({
    required LatLng start,
    required LatLng end
  }) async {
    var body = {
      'coordinates': [
        [start.longitude, start.latitude],
        [end.longitude, end.latitude],
      ]
    };

    http.Response response = await sendOpenStreetRouteRequest(endpoint: 'directions/driving-car/geojson', body: body);

    if (response.statusCode != 200) {
      return null;
    }

    var decoded = jsonDecode(response.body);
    var coordinatesJson = decoded['features'][0]['geometry']['coordinates'];
    var ret = <LatLng>[];

    for (var c in coordinatesJson)
      ret.add(LatLng(c[1], c[0]));

    return ret;
  }
}
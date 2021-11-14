import 'package:equatable/equatable.dart';
import 'package:location/location.dart';
import 'package:neptune_app/common/constants.dart' as constants;
import 'package:neptune_app/common/util/location_info.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart';

import 'latlng.dart';

class LocationUtil {
  static const double _radianPerDegree = math.pi / 180;
  static const double _degreePerRadian = 1 / _radianPerDegree;
  static const double earthRadiusMeter = constants.earthRadiusMeter;
  static final kmuttLatLng = constants.kmuttLatLng;

  static bool isProjectionInside({
    required LatLng start,
    required LatLng end,
    required LatLng proj,
  }) {
    var dac = earthSurfaceDistance(start, end);
    var dab = earthSurfaceDistance(start, proj);
    var dbc = earthSurfaceDistance(end, proj);

    // return dab + dbc <= dac + 1e-4;

    var ratio = ((dab + dbc) / dac - 1) / 1e-5;

    return ratio >= -1 && ratio <= 1;
  }

  static Vector3 greatCircleNormal({
    required LatLng start,
    required LatLng end,
  }) {
    var a = earthToUnit3D(start);
    var b = earthToUnit3D(end);
    var n = a.cross(b);
    n = n.normalized();
    return n;
  }

  static LatLng greatCircleProjection({
    required LatLng start,
    required LatLng end,
    required LatLng point,
  }) {
    // https://stackoverflow.com/a/1302268
    var g = earthToUnit3D(start).cross(earthToUnit3D(end));
    var f = earthToUnit3D(point).cross(g);
    var t = g.cross(f);

    var r = unit3DToEarth(t.normalized());
    return r;
  }

  static Vector3 earthToUnit3D(LatLng a) {
    var lat = _radianPerDegree * a.latitude;
    var lng = _radianPerDegree * a.longitude;
    return Vector3(
        math.cos(lng) * math.cos(lat),
        math.sin(lng) * math.cos(lat),
        math.sin(lat)
    ).normalized();
  }

  static LatLng unit3DToEarth(Vector3 a) {
    return LatLng(
        math.asin(a.z) * _degreePerRadian,
        math.atan2(a.y, a.x) * _degreePerRadian
    );
  }

  static double earthSurfaceDistance(LatLng u, LatLng v) {
    var ulat = u.latitude * _radianPerDegree;
    var ulng = u.longitude * _radianPerDegree;
    var vlat = v.latitude * _radianPerDegree;
    var vlng = v.longitude * _radianPerDegree;

    var dlat = vlat - ulat;
    var dlng = vlng - ulng;

    var a = math.sin(dlat / 2) * math.sin(dlat / 2) +
            math.cos(ulat) * math.cos(vlat) *
            math.sin(dlng/2) * math.sin(dlng/2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var d = earthRadiusMeter * c;

    return d;
  }

  static Future<Location?> getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    location.onLocationChanged;

    return location;
  }

  static Stream<LocationInfo> getLocationInfoStream() async* {
    var location = await getLocation();
    if (location == null) {
      return;
    }

    var prev;
    var prevTime;
    await for (var data in location.onLocationChanged) {
      var latlng = data.toCommonType();
      if (latlng == null) {
        continue;
      }

      if (data.speed != null) {
        yield LocationInfo(location: latlng, speed: data.speed!);
      } else {
        throw new Exception("speed not available"); // TODO: speed calc
        // var dist = earthSurfaceDistance(prev, latlng);
        // data.elapsedRealtimeNanos
      }

      prev = data;
      prevTime = DateTime.now();
    }
  }
}

class MapInfo extends Equatable {
  final LatLng currentPosition;
  final List<LatLng> route;

  MapInfo({
    required this.currentPosition,
    this.route = const [],
  }) : assert(route.length == 0 || route.length >= 2);

  @override
  List<Object?> get props => [currentPosition, route];
}
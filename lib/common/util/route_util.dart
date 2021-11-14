import 'package:neptune_app/common/util/location_util.dart';

import 'latlng.dart';

class RouteUtil {
  static List<LatLng>? updateRouteIfSame({
    required List<LatLng> oldRoute,
    required LatLng currentLocation,
    required double maxDist,
  }) {
    var reversed = routeToEndAt(
        route: oldRoute.reversed.toList(),
        end: currentLocation,
        maxDist: maxDist
    );

    if (reversed == null)
      return null;

    return reversed.reversed.toList();
  }

  static List<LatLng>? routeToEndAt({
    required List<LatLng> route,
    required LatLng end,
    required double maxDist,
  }) {
    assert(route.length >= 2);

    var prev = route[0];
    var newRoute = <LatLng>[];
    for (var coord in route.skip(1)) {
      newRoute.add(prev);

      var endProj = LocationUtil.greatCircleProjection(start: prev, end: coord, point: end);
      if (LocationUtil.isProjectionInside(start: prev, end: coord, proj: endProj)) {
        var dist = LocationUtil.earthSurfaceDistance(end, endProj);
        if (dist > maxDist) {
          continue; // Consider the case with 90 degrees turn. Can project to both, but only choose the closest.
        }

        newRoute.add(endProj);
        return newRoute;
      }
      prev = coord;
    }

    return null;
  }

  static double calculateRouteLength(List<LatLng> route) {
    assert(route.length >= 2);

    var prev = route[0];
    var dist = 0.0;
    for (var coord in route.skip(1)) {
      dist += LocationUtil.earthSurfaceDistance(prev, coord);
      prev = coord;
    }

    return dist;
  }
}
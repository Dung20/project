import 'package:neptune_app/common/api/open_route_service_api.dart';
import 'package:neptune_app/common/util/latlng.dart';
import 'package:neptune_app/common/util/route_util.dart';

class RouteRepository {
  final OpenRouteServiceApi openRouteServiceApi;

  RouteRepository(this.openRouteServiceApi);

  Future<List<LatLng>?> updateRoute({
    required List<LatLng>? oldRoute,
    required LatLng start,
    required LatLng end
  }) async {
    if (oldRoute == null || oldRoute.last != end) {
      return openRouteServiceApi.getRoute(start: start, end: end);
    }

    var newRoute = RouteUtil.updateRouteIfSame(oldRoute: oldRoute, currentLocation: start, maxDist: 100);

    if (newRoute == null) {
      return openRouteServiceApi.getRoute(start: start, end: end);
    }

    return newRoute;
  }
}

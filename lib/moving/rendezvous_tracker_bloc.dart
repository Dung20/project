import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neptune_app/common/constants.dart';
import 'package:neptune_app/common/repositories/route_repository.dart';
import 'package:neptune_app/common/repositories/vehicle_repository.dart';
import 'package:neptune_app/common/util/latlng.dart';
import 'package:neptune_app/common/util/location_info.dart';
import 'package:neptune_app/common/util/location_util.dart';
import 'package:neptune_app/common/util/route_util.dart';
import 'package:neptune_app/moving/rendezvous_info.dart';

part 'rendezvous_tracker_event.dart';
part 'rendezvous_tracker_state.dart';

class RendezvousTrackerBloc extends Bloc<RendezvousTrackerEvent, RendezvousTrackerState> {
  final RouteRepository routeRepository;
  final VehicleRepository vehicleRepository;
  StreamSubscription<LocationInfo>? _streamSubscription;

  RendezvousTrackerBloc({
    required this.routeRepository,
    required this.vehicleRepository,
  }) : super(RendezvousTrackerUninitialized());

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  @override
  Stream<RendezvousTrackerState> mapEventToState(
    RendezvousTrackerEvent event,
  ) async* {
    if (event is RendezvousTrackerDestinationChose) {
      _streamSubscription = LocationUtil.getLocationInfoStream().listen((l) =>
          add(RendezvousTrackerLocationUpdated(currentLocation: l)));
      yield RendezvousTrackerInitialized(destination: event.destination);
    }
    if (event is RendezvousTrackerLocationUpdated) {
      if (state is RendezvousTrackerUninitialized) {
        return;
      }

      var dest;
      var oldRoute;
      if (state is RendezvousTrackerInitialized) {
        dest = (state as RendezvousTrackerInitialized).destination;
      } else {
        var state = this.state as RendezvousTrackerTracking;
        oldRoute = state.route;
        dest = oldRoute.last;
      }

      var userLocation = event.currentLocation;
      var userCoord = userLocation.location;

      var newRoute = await routeRepository.updateRoute(
          oldRoute: oldRoute,
          start: userCoord,
          end: dest,
      );
      
      if (newRoute == null) { // TODO: this has been fired.
        // addError(Exception("newRoute == null"));
        print("newRoute == null");
        return;
      }

      var vehiclesCoords = await vehicleRepository.getVehiclesInRadius(
          radius: movingMaximumVehicleRadius,
          location: userCoord,
      );

      var vehicles = <RendezvousInfo>[];
      if (vehiclesCoords != null) {
        for (var coord in vehiclesCoords) {
          var route = RouteUtil.routeToEndAt(route: newRoute, end: coord, maxDist: movingMaximumSameRouteDeviation);
          if (route == null) {
            print('route == null');
            continue;
          }

          var dist = RouteUtil.calculateRouteLength(route);
          vehicles.add(RendezvousInfo(
              location: coord,
              distance: dist,
              time: dist / userLocation.speed,
          ));
        }
      }

      yield RendezvousTrackerTracking(
          route: newRoute,
          vehicles: vehicles,
          speed: userLocation.speed,
      );
    }
    if (event is RendezvousTrackerStop) {
      _streamSubscription?.cancel();
      _streamSubscription = null;
      yield RendezvousTrackerUninitialized();
    }
  }
}

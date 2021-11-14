part of 'rendezvous_tracker_bloc.dart';

abstract class RendezvousTrackerState extends Equatable {
  const RendezvousTrackerState();

  @override
  List<Object> get props => [];
}

class RendezvousTrackerUninitialized extends RendezvousTrackerState {}

class RendezvousTrackerInitialized extends RendezvousTrackerState {
  final LatLng destination;

  RendezvousTrackerInitialized({required this.destination});

  @override
  List<Object> get props => [destination];
}

class RendezvousTrackerTracking extends RendezvousTrackerState {
  final List<LatLng> route;
  final List<RendezvousInfo> vehicles;
  final double speed;

  RendezvousTrackerTracking({
    required this.route,
    required this.vehicles,
    required this.speed,
  });

  @override
  List<Object> get props => [route, vehicles, speed];
}

part of 'rendezvous_tracker_bloc.dart';

abstract class RendezvousTrackerEvent extends Equatable {
  const RendezvousTrackerEvent();

  @override
  List<Object> get props => [];
}

class RendezvousTrackerDestinationChose extends RendezvousTrackerEvent {
  final LatLng destination;

  RendezvousTrackerDestinationChose({required this.destination});

  @override
  List<Object> get props => [destination];
}

class RendezvousTrackerLocationUpdated extends RendezvousTrackerEvent {
  final LocationInfo currentLocation;

  RendezvousTrackerLocationUpdated({required this.currentLocation});

  @override
  List<Object> get props => [currentLocation];
}

class RendezvousTrackerStop extends RendezvousTrackerEvent {}

part of 'location_recorder_bloc.dart';

abstract class LocationRecorderEvent extends Equatable {
  const LocationRecorderEvent();

  @override
  List<Object> get props => [];
}

class LocationRecorderDisabled extends LocationRecorderEvent {}

class LocationRecorderStarted extends LocationRecorderEvent {}

class LocationRecorderUpdated extends LocationRecorderEvent {
  final LocationInfo location;

  const LocationRecorderUpdated({required this.location});

  @override
  List<Object> get props => [location];
}

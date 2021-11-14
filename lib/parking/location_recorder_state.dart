part of 'location_recorder_bloc.dart';

abstract class LocationRecorderState extends Equatable {
  const LocationRecorderState();

  @override
  List<Object> get props => [];
}

class LocationRecorderUntracked extends LocationRecorderState {
}

class LocationRecorderMoving extends LocationRecorderState {
  final LocationInfo locationInfo;

  const LocationRecorderMoving({required this.locationInfo});

  @override
  List<Object> get props => [locationInfo];
}

class LocationRecorderParked extends LocationRecorderState {
  final LocationInfo locationInfo;

  const LocationRecorderParked({required this.locationInfo});

  @override
  List<Object> get props => [locationInfo];
}

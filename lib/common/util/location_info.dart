import 'package:equatable/equatable.dart';

import 'latlng.dart';

class LocationInfo extends Equatable {
  final LatLng location;
  final double speed;
  final double? altitude;

  LocationInfo({required this.location, required this.speed, this.altitude});

  @override
  List<Object?> get props => [location, speed, altitude];
}

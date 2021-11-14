import 'package:equatable/equatable.dart';
import 'package:neptune_app/common/util/latlng.dart';

class RendezvousInfo extends Equatable {
  final LatLng location;
  final double distance;
  final double time;

  RendezvousInfo({required this.location, required this.distance, required this.time});

  @override
  List<Object> get props => [location, distance, time];
}
